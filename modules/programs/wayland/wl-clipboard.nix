{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.wayland.wl-clipboard;
in
{
  options.modules.programs.wayland.wl-clipboard.enable = lib.mkEnableOption "wl-clipboard module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.wl-clipboard ];
  };
}
