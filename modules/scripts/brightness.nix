{ config, pkgs, lib, ... }:

let
  cfg = config.modules.scripts.brightness;

  dependencies = [
    pkgs.brightnessctl
    pkgs.bc
    pkgs.libnotify
  ];

  brightness = pkgs.writeShellScriptBin "brightness" (''
    PATH="${lib.makeBinPath dependencies}:$PATH"
  '' + builtins.readFile "${config.scripts.brightness}");
in
{
  options.modules.scripts.brightness.enable = lib.mkEnableOption "brightness script";

  config = lib.mkIf cfg.enable {
    modules.txn.icons.enable = true;
    home.packages = dependencies ++ [ brightness ];
    home.file = {
      "scripts/brightness".source = config.lib.file.mkOutOfStoreSymlink "${config.scripts.brightness}";
    };
  };
}
