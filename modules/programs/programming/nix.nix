{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.nix;
in
{
  options.modules.programs.nix = {
    enable = lib.mkEnableOption "nix module";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.nil
    ];
  };
}
