{ config, pkgs, lib, ... }:

{
  config = {
    modules = {
      scripts.enable = true;
      programs = {
        hyprland.enable   = true;
        swayidle.enable   = true;
      };
    };
  };
}
