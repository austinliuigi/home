{ config, pkgs, lib, utils, ... }:

let
  cfg = config.configuration;

  # FIXME: Temporary implementation until pkgs.replaceVarsWith allows using --replace-quiet instead of --replace-quit
  # - https://github.com/hsjobeki/nixpkgs/blob/migrate-doc-comments/pkgs/build-support/replace-vars/replace-vars-with.nix
  replaceVarsWith = {
    src,
    replacements,
    dir ? null,
    isExecutable ? false,
    ...
  }@attrs:

  let
    # We use `--replace-fail` instead of `--subst-var-by` so that if the thing isn't there, we fail.
    subst-var-by = name: value: [
      "--replace-quiet"
      (lib.escapeShellArg "@${name}@")
      (lib.escapeShellArg (lib.defaultTo "@${name}@" value))
    ];

    substitutions = lib.concatLists (lib.mapAttrsToList subst-var-by replacements);

    left-overs = map ({ name, ... }: name) (
      builtins.filter ({ value, ... }: value == null) (lib.attrsToList replacements)
    );

    optionalAttrs =
      if (builtins.intersectAttrs attrs forcedAttrs == { }) then
        builtins.removeAttrs attrs [ "replacements" ]
      else
        throw "Passing any of ${builtins.concatStringsSep ", " (builtins.attrNames forcedAttrs)} to replaceVarsWith is not supported.";

    forcedAttrs = {
      doCheck = true;
      dontUnpack = true;
      preferLocalBuild = true;
      allowSubstitutes = false;

      buildPhase = ''
        runHook preBuild

        target=$out
        if test -n "$dir"; then
            target=$out/$dir/$name
            mkdir -p $out/$dir
        fi

        substitute "$src" "$target" ${lib.concatStringsSep " " substitutions}

        if test -n "$isExecutable"; then
            chmod +x $target
        fi

        runHook postBuild
      '';

      # Look for Nix identifiers surrounded by `@` that aren't substituted.
      checkPhase =
        let
          lookahead =
            if builtins.length left-overs == 0 then "" else "(?!${builtins.concatStringsSep "|" left-overs}@)";
          regex = lib.escapeShellArg "@${lookahead}[a-zA-Z_][0-9A-Za-z_'-]*@";
        in
        ''
          runHook preCheck
          if grep -Pqe ${regex} "$target"; then
            echo The following look like unsubstituted Nix identifiers that remain in "$target":
            grep -Poe ${regex} "$target"
            echo Use the more precise '`substitute`' function if this check is in error.
            exit 1
          fi
          runHook postCheck
        '';
    };
  in

  pkgs.stdenvNoCC.mkDerivation (
    {
      name = baseNameOf (toString src);
    }
    // optionalAttrs
    // forcedAttrs
  );

  # FIXME: Temporary implementation until pkgs.replaceVarsWith allows using --replace-quiet instead of --replace-quit
  # - https://github.com/hsjobeki/nixpkgs/blob/migrate-doc-comments/pkgs/build-support/replace-vars/replace-vars-with.nix
  replaceVars = src: replacements: replaceVarsWith { inherit src replacements; };

  # Generate a map from filepaths to substitute derivations for each file within a directory
  #   - param dir: path - top level directory that holds all files that should get substituted
  #   - param replacements: attr - map from strings that should get replaced to their respective replacements
  #     - key = <match>: str - files that contain the text @<match>@ get replaced
  #     - val = <replacement>: str - the text that should replace @<match>@ in the file
  #   - return substitutions: attr - map from filepaths to substitute derivations
  #     - key = <filepath>: str - filepath relative to dir
  #     - val = <substituted_file>: derivation - derivation that builds the file with substituted replacements
  substituteDirFiles = { dir, replacements }:
    (builtins.listToAttrs
      (builtins.map
        (file:
          {
            name = file;
            value = replaceVars "${utils.toStorePath dir}/${file}" replacements;
          }
        )
        (utils.scanDirFiles { dir = dir; })
      )
    );


  # Interpolate values in configuration files
  #   - param dir: str|path directory which contains configurations files
  #   - return substitutions: attr
  #     - key = <filepath>: str - filepath relative to dir
  #     - val = { source = <substituted_file> }: attr - <substituted_file> is a derivation that builds the file with substituted replacements
  interpolateConfigDir = dir:
    builtins.mapAttrs
      (file: substituted: { source = substituted; })
      (substituteDirFiles { 
        dir = dir;
        replacements = cfg.substitutions;
      });


  # Interpolate values in configuration files with added message
  #   - param dir: str|path directory which contains configuration files
  #   - param comment_start: str string which config files use to start comments
  #   - param comment_end: str string which config files use to end comments
  #   - return substitutions: attr
  #     - key = <filepath>: str - filepath relative to dir
  #     - val = { text = <contents> }: attr - <contents> is a string representing the new file's contents
  interpolateConfigDirWithMsg = { dir, comment_start ? "", comment_end ? "" }:
    builtins.mapAttrs
      (file: interpolatedFile: {
        text = ''
        ${comment_start} NOTE: This is an interpolated copy of the respective file in ${dir}/${file} ${comment_end}

        '' + builtins.readFile interpolatedFile;
      })
      (substituteDirFiles { 
        dir = dir;
        replacements = cfg.substitutions;
      });


  # Interpolate values in a configuration file
  #   - param file: str|path path to the configuration file to interpolate
  #   - return { source = <substituted_file> }: attr - <substituted_file> is a derivation that builds the file with substituted replacements
  #
  # e.g. home.file."foo/bar".source = interpolateConfigFile "/nix/store/.../foo/bar"
  interpolateConfigFile = file:
    replaceVars (utils.toStorePath file) cfg.substitutions;


  # Interpolate values in configuration files with added message
  #   - param file: str|path path to the configuration file to interpolate
  #   - param comment_start: str string which config files use to start comments
  #   - param comment_end: str string which config files use to end comments
  #   - return { text = <contents> }: attr - <contents> is a string representing the new file's contents
  #
  # e.g. home.file."foo/bar".text = interpolateConfigFileWithMsg { file = "/nix/store/.../foo/bar"; comment_start = "#"; }
  interpolateConfigFileWithMsg = { file, comment_start ? "", comment_end ? "" }:
    let
      msg = ''
        ${comment_start} NOTE: This is an interpolated copy of ${file} ${comment_end}

      '';

      interpolatedFile = replaceVars (utils.toStorePath file) cfg.substitutions;
    in
    "${msg}" + builtins.readFile interpolatedFile;
in
  {
    options.configuration = {
      substitutions = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
      };

      interpolateConfigDir = lib.mkOption {
        readOnly = true;
        default = interpolateConfigDir;
      };
      interpolateConfigDirWithMsg = lib.mkOption {
        readOnly = true;
        default = interpolateConfigDirWithMsg;
      };
      interpolateConfigFile = lib.mkOption {
        readOnly = true;
        default = interpolateConfigFile;
      };
      interpolateConfigFileWithMsg = lib.mkOption {
        readOnly = true;
        default = interpolateConfigFileWithMsg;
      };
    };
  }
