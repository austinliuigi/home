{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.wayland.waybar;
in
{
  options.modules.programs.wayland.waybar.enable = lib.mkEnableOption "waybar module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.waybar ];
  };
}
