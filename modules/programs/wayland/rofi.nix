{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.wayland.rofi;
in
{
  options.modules.programs.wayland.rofi.enable = lib.mkEnableOption "rofi module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.rofi-wayland ];

    home.file = {
      ".local/share/rofi/themes/_palette.rasi".text = config.configuration.interpolateConfigFileWithMsg { file = "${/. + "${config.dotfiles.rofi}/.local/share/rofi/themes/_palette.rasi"}"; comment_start = "//"; };
      ".local/share/rofi/scripts".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.rofi}/.local/share/rofi/scripts";
      ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.rofi}/.config/rofi";
    };
  };
}
