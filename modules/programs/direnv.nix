{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.direnv;
in
{
  options.modules.programs.direnv.enable = lib.mkEnableOption "direnv module";

  config = lib.mkIf cfg.enable {
     programs.direnv = {
        enable = true;
        enableBashIntegration = true; # see note on other shells below
        nix-direnv.enable = true;
      };
  };
}
