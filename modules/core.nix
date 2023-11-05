{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.core;
in
{
  options = {
    modules.core = {
      enable = lib.mkEnableOption "Core utilities";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.zsh
      pkgs.fzf
      pkgs.python3
      pkgs.nodejs
      pkgs.deno
    ];
  };
}
