{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.wayland.hyprpicker;
in
{
  options.modules.programs.wayland.hyprpicker.enable = lib.mkEnableOption "hyprpicker module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.hyprpicker ];
  };
}
