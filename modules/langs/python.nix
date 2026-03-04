{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.langs.python;
in {
  options.modules.langs.python = {
    enable = lib.mkEnableOption "python module";
  };

  options.pythonLibraries = lib.mkOption {
    type = with lib.types; listOf str;
    default = [];
    description = ''
      Python libraries to install so that they are able to be imported by the user's python installation.
      Each entry should be the name of the library's nix package within pythonXPackages, e.g. "pynvim" for python3Packages.pynvim.
    '';
  };

  options.pythonPaletteLinks = lib.mkOption {
    type = with lib.types; listOf str;
    default = [];
    description = ''
      Symlinks to the automatically generated python palette.
    '';
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.poetry
      pkgs.pyright
      pkgs.black
      (
        pkgs.python314.withPackages (
          ps:
            with ps;
              [
                virtualenv
                debugpy
                pylint
              ]
              ++ builtins.map (lib: ps.${lib}) config.pythonLibraries
        )
      )
    ];
    home.file = {
      ".local/share/python/palette.py" = {
        text = config.configuration.interpolateConfigFileWithMsg {
          file = "${config.dotfiles.python}/.local/share/python/palette.py";
          comment_start = "#";
        };
        # HACK: symlink palette to local packages that need it because the alternative is to import palette using its relative path, which sucks when symlinks are involved
        onChange = builtins.concatStringsSep "\n" (map (file: "ln -s ~/.local/share/python/palette.py ${file} || true") config.pythonPaletteLinks);
      };
    };
  };
}
