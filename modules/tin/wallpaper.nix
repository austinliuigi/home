{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.tin.wallpaper;
in
{
  options.modules.tin.wallpaper.enable = lib.mkEnableOption "tin's wallpaper module";

  config = lib.mkIf cfg.enable {
    home.file = {
      ".local/share/tin/wallpapers".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.tin}/.local/share/tin/wallpapers";

      ".cache/palette.dummy".onChange = ''
        echo "tin: generating wallpaper"

        cd ~/.local/share/tin/wallpapers
        mkdir -p ~/.cache/tin && ${pkgs.imagemagick}/bin/magick _wallpaper.png -fill "#${config.colorscheme.colors.base02}" -tint 100 ~/.cache/tin/wallpaper.png 2>/dev/null
      '';
    };
  };
}
