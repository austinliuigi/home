{ config, pkgs, lib, ... }:

let
  cfg = config.modules.scripts.fzmenu;

  dependencies = [
    pkgs.j4-dmenu-desktop
    pkgs.cliphist
  ];

  # fzmenu = pkgs.writeShellScriptBin "fzmenu" (''
  #   PATH="${lib.makeBinPath dependencies}:$PATH"
  # '' + builtins.readFile "${config.scripts.fzmenu}/default.sh");
in
{
  options.modules.scripts.fzmenu.enable = lib.mkEnableOption "fzmenu script";

  config = lib.mkIf cfg.enable {
    home.packages = dependencies;

    home.file = {
      "scripts/fzmenu".source = config.lib.file.mkOutOfStoreSymlink "${config.scripts.fzmenu}";
      ".local/bin/fzmenu".source = config.lib.file.mkOutOfStoreSymlink "${config.scripts.fzmenu}/default.sh";
    };
  };
}
