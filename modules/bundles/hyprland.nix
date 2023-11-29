{ config, pkgs, lib, ... }:

let
  cfg = config.modules.bundles.hyprland;
in
{
  options.modules.bundles.hyprland.enable = lib.mkEnableOption "hyprland bundle module";

  config = lib.mkIf cfg.enable {
    modules = {
      scripts.enable = true;
      programs = {
        wayland.hyprland.enable   = true;
        wayland.swayidle.enable   = true;
        wayland.rofi.enable       = true;
        wayland.waybar.enable     = true;
        wayland.wl-clipboard.enable = true;
      };
    };
  };
}
