{ config, pkgs, lib, ... }:

let
  cfg = config.modules.scripts.wayland.screenshot;

  dependencies = [
    pkgs.fd
    pkgs.grim
    pkgs.wl-screenrec
    pkgs.libva-utils
    pkgs.slurp
    pkgs.rofi-wayland
    pkgs.wl-clipboard
    pkgs.libnotify
  ];

  # screenshot = pkgs.writeShellScriptBin "screenshot" (''
  #   PATH="${lib.makeBinPath dependencies}:$PATH"
  # '' + builtins.readFile "${config.scripts.screenshot}");
in
{
  options.modules.scripts.wayland.screenshot.enable = lib.mkEnableOption "screenshot script";

  config = lib.mkIf cfg.enable {
    modules.txn.icons.enable = true;

    home.packages = dependencies;

    home.file = {
      "scripts/screenshot".source = config.lib.file.mkOutOfStoreSymlink "${config.scripts.screenshot}";
      ".local/bin/screenshot".source = config.lib.file.mkOutOfStoreSymlink "${config.scripts.screenshot}";
    };
  };
}
