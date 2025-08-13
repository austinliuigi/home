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

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.poetry
      pkgs.pyright
      (pkgs.python311.withPackages (ps:
        with ps;
          [
            virtualenv
            debugpy
            pylint
          ]
          ++ builtins.map (lib: ps.lib) config.pythonLibraries))
    ];
  };
}
