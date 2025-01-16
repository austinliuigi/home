{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.localsend;
in
{
  options.modules.programs.localsend.enable = lib.mkEnableOption "localsend module";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.localsend
    ];
  };
}
