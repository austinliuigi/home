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
        hyprland.enable   = true;
        swayidle.enable   = true;
      };
    };
  };
}
