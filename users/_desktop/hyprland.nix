{ config, pkgs, lib, ... }:

{
  modules = {
    scripts = {
      wayland.screenshot.enable = true;
    };
    programs = {
      wayland.hyprland.enable   = true;
      wayland.swayidle.enable   = true;
      wayland.swww.enable       = true;
      wayland.rofi.enable       = true;
      wayland.waybar.enable     = true;
      wayland.wl-clipboard.enable = true;
    };
  };
}
