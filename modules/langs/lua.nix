{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.langs.lua;
in {
  options.modules.langs.lua = {
    enable = lib.mkEnableOption "lua module";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.stylua
      pkgs.lua-language-server
    ];
  };
}
