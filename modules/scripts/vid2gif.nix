{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.scripts.vid2gif;

  dependencies = [
    pkgs.ffmpeg
    pkgs.gifsicle
  ];
in {
  options.modules.scripts.vid2gif.enable = lib.mkEnableOption "vid2gif script";

  config = lib.mkIf cfg.enable {
    home.packages = dependencies;

    home.file = {
      "scripts/vid2gif".source = config.lib.file.mkOutOfStoreSymlink "${config.scripts.vid2gif}";
      ".local/bin/vid2gif".source = config.lib.file.mkOutOfStoreSymlink "${config.scripts.vid2gif}";
    };
  };
}
