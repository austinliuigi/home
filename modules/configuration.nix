{ config, pkgs, lib, utils, ... }:

let
  cfg = config.configuration;

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
            value = pkgs.substituteAll ({
              src = "${dir}/${file}";
            } // replacements);
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
    let
      msg = ''
        ${comment_start} NOTE: This is an interpolated copy and shouldn't be modified directly. ${comment_end}

      '';
    in
    builtins.mapAttrs
      (file: interpolatedFile: {
        text = "${msg}" + builtins.readFile(interpolatedFile);
      })
      (substituteDirFiles { 
        dir = dir;
        replacements = cfg.substitutions;
      });


  # Interpolate values in a configuration file
  #   - param file: str|path path to the configuration file to interpolate
  #   - return { source = <substituted_file> }: attr - <substituted_file> is a derivation that builds the file with substituted replacements
  interpolateConfigFile = file:
    {
      source = pkgs.substituteAll ({
        src = "${file}";
      } // cfg.substitutions);
    };


  # Interpolate values in configuration files with added message
  #   - param file: str|path path to the configuration file to interpolate
  #   - param comment_start: str string which config files use to start comments
  #   - param comment_end: str string which config files use to end comments
  #   - return { text = <contents> }: attr - <contents> is a string representing the new file's contents
  interpolateConfigFileWithMsg = { file, comment_start ? "", comment_end ? "" }:
    let
      msg = ''
        ${comment_start} NOTE: This is an interpolated copy and shouldn't be modified directly. ${comment_end}

      '';

      interpolatedFile = pkgs.substituteAll ({
        src = "${file}";
      } // cfg.substitutions);
    in
    { text = "${msg}" + builtins.readFile(interpolatedFile); };
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
