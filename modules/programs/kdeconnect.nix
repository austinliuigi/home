{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.kdeconnect;
in
{
  options.modules.programs.kdeconnect.enable = lib.mkEnableOption "kdeconnect module";

  config = lib.mkIf cfg.enable {
    services.kdeconnect = {
      enable = true;
    };
  };
}
