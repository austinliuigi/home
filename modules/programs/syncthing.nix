{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.syncthing;
in
{
  options.modules.programs.syncthing.enable = lib.mkEnableOption "syncthing module";

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
    };
  };
}
