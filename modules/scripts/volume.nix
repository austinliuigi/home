{ config, pkgs, lib, ... }:

let
  cfg = config.modules.scripts.volume;

  dependencies = [
    pkgs.pamixer
    pkgs.libnotify
  ];

  # volume = pkgs.writeShellScriptBin "volume" (''
  #   PATH="${lib.makeBinPath dependencies}:$PATH"
  # '' + builtins.readFile "${config.scripts.volume}");
in
{
  options.modules.scripts.volume.enable = lib.mkEnableOption "volume script";

  config = lib.mkIf cfg.enable {
    modules.txn.icons.enable = true;

    home.packages = dependencies;

    home.file = {
      "scripts/volume".source = config.lib.file.mkOutOfStoreSymlink "${config.scripts.volume}";
      ".local/bin/volume".source = config.lib.file.mkOutOfStoreSymlink "${config.scripts.volume}";
    };
  };
}
