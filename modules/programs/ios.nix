{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.ios;
in
{
  options.modules.programs.ios.enable = lib.mkEnableOption "ios module";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.libimobiledevice
      pkgs.ifuse
    ];
  };
}
