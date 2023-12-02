{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.pcmanfm;
in
{
  options.modules.programs.pcmanfm.enable = lib.mkEnableOption "pcmanfm module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.pcmanfm ];
  };
}
