{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.common;
in
{
  options.modules.programs.common.enable = lib.mkEnableOption "common utilities module";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.btop
      pkgs.fd
      pkgs.jq
      pkgs.lsd
      pkgs.ripgrep
      pkgs.ripgrep-all
      pkgs.tealdeer
      pkgs.inetutils
      pkgs.dig
    ];
  };
}
