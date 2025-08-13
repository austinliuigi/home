{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.langs.nix;
in {
  options.modules.langs.nix = {
    enable = lib.mkEnableOption "nix module";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      # pkgs.nil
      pkgs.nixd
      pkgs.alejandra
    ];
  };
}
