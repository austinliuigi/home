{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.common;
in
{
  options.modules.programs.common.enable = lib.mkEnableOption "common utilities module";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.btop # htop improvement
      pkgs.lsd # ls improvement
      pkgs.fd # find improvement
      pkgs.ripgrep # grep improvement
      pkgs.ripgrep-all
      pkgs.dysk # df improvement

      pkgs.jq
      pkgs.tealdeer
      pkgs.inetutils
      pkgs.dig
    ];
  };
}
