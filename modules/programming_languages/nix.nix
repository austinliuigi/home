{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programming_languages.nix;
in
{
  options.modules.programming_languages.nix = {
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
