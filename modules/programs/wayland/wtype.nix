{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.wayland.wtype;
in
{
  options.modules.programs.wayland.wtype.enable = lib.mkEnableOption "wtype module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.wtype ];
  };
}
