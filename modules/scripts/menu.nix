{ config, pkgs, lib, ... }:

let
  cfg = config.modules.scripts.menu;

  dependencies = [
    pkgs.cliphist
  ];

  menu = pkgs.writeShellScriptBin "menu" (''
    PATH="${lib.makeBinPath dependencies}:$PATH"
  '' + builtins.readFile "${config.scripts.menu}/default.sh");
in
{
  options.modules.scripts.menu.enable = lib.mkEnableOption "menu script";

  config = lib.mkIf cfg.enable {
    home.packages = dependencies ++ [ menu ];

    home.file = {
      "scripts/menu".source = config.lib.file.mkOutOfStoreSymlink "${config.scripts.menu}";
    };
  };
}
