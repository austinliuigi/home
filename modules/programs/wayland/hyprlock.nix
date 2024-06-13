{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.wayland.hyprlock;
in
{
  options.modules.programs.wayland.hyprlock.enable = lib.mkEnableOption "hyprlock module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.hyprlock ];

    home.file = {
      ".config/hypr/hyprlock.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.hyprlock}/.config/hypr/hyprlock.conf";
    };
  };
}
