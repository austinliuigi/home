{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.kitty;
in
{
  options.modules.programs.kitty.enable = lib.mkEnableOption "kitty module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.kitty ];

    home.file = {
      ".local/share/kitty/theme.conf" = config.configuration.interpolateConfigFileWithMsg { file = "${/. + "${config.dotfiles.kitty}/.local/share/kitty/theme.conf"}"; comment_start = "#"; };
      ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.kitty}/.config/kitty";
    };
  };
}
