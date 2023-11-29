{ config, pkgs, lib, ... }:

{
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
}
