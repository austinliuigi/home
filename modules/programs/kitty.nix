{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.kitty;
in
{
  options.modules.programs.kitty.enable = lib.mkEnableOption "kitty module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.kitty ];

    home.file = {
      ".local/state/kitty/theme.conf" = config.configuration.interpolateConfigFileWithMsg { file = "${/. + "${config.dotfiles.kitty}/.local/state/kitty/theme.conf"}"; comment_start = "#"; };
    };

    xdg.configFile = {
      kitty.source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.kitty}/.config/kitty";
    };
  };
}
