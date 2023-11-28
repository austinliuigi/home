{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.lua;
in
{
  options.modules.programs.lua = {
    enable = lib.mkEnableOption "lua module";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.stylua
      pkgs.lua-language-server
    ];
  };
}
