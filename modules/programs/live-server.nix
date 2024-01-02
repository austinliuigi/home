{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.live-server;
in
{
  options.modules.programs.live-server.enable = lib.mkEnableOption "live-server module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.nodePackages_latest.live-server ];
  };
}
