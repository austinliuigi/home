{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programming_languages.lua;
in
{
  options.modules.programming_languages.lua = {
    enable = lib.mkEnableOption "lua module";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.stylua
      pkgs.lua-language-server
    ];
  };
}
