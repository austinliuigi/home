{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.txn.wallpaper;
in
{
  options.modules.txn.wallpaper.enable = lib.mkEnableOption "txn's wallpaper module";

  config = lib.mkIf cfg.enable {
    home.file = {
      ".local/share/txn/wallpapers".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.txn}/.local/share/txn/wallpapers";

      ".cache/palette.dummy".onChange = ''
        echo "txn: generating wallpaper"

        cd ~/.local/share/txn/wallpapers
        mkdir -p ~/.cache/txn && ${pkgs.imagemagick}/bin/magick _wallpaper.png -fill "#${config.colorscheme.palette.base02}" -tint 100 ~/.cache/txn/wallpaper.png 2>/dev/null
      '';
    };
  };
}
