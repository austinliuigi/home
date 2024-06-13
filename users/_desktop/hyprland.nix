{ config, pkgs, lib, ... }:

{
  modules = {
    scripts = {
      battery.enable = true;
      brightness.enable = true;
      volume.enable = true;
      wayland.screenshot.enable = true;
    };
    programs = {
      wayland.hyprland.enable   = true;
      wayland.hypridle.enable   = true;
      wayland.hyprlock.enable   = true;
      wayland.swww.enable       = true;
      wayland.swayidle.enable   = false;
      wayland.rofi.enable       = true;
      wayland.waybar.enable     = true;
      wayland.wl-clipboard.enable = true;
    };
  };
}
