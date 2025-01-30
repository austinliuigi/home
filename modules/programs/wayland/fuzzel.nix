{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.fuzzel;
in
{
  options.modules.programs.fuzzel.enable = lib.mkEnableOption "fuzzel module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.fuzzel ];

    home.file = {
      ".config/fuzzel".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.fuzzel}/.config/fuzzel";
      ".local/share/fuzzel/palette.ini".text = config.configuration.interpolateConfigFileWithMsg { file = "${config.dotfiles.fuzzel}/.local/share/fuzzel/palette.ini"; comment_start = "#"; };
      ".local/share/fuzzel/font.ini".text = config.configuration.interpolateConfigFileWithMsg { file = "${config.dotfiles.fuzzel}/.local/share/fuzzel/font.ini"; comment_start = "#"; };
    };
  };
}
