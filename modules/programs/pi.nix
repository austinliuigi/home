{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.programs.pi;
in {
  options.modules.programs.pi.enable = lib.mkEnableOption "pi module";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.pi-coding-agent
      pkgs.nodejs
      pkgs.bun
    ];

    home.sessionVariables = {
      PI_CODING_AGENT_DIR = "${config.xdg.configHome}/pi";
    };

    home.file = {
      ".config/pi".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.pi}/.config/pi";
    };
  };
}
