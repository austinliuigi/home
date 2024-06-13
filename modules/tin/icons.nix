{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.tin.icons;
in
{
  options.modules.tin.icons.enable = lib.mkEnableOption "tin's icons module";

  config = lib.mkIf cfg.enable {
    home.file = {
      ".local/share/tin/icons".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.tin}/.local/share/tin/icons";

      ".cache/palette.dummy".onChange = ''
        echo "tin: generating icons"

        cd ~/.local/share/tin/icons
        mkdir -p ~/.cache/tin/icons && ${pkgs.imagemagick}/bin/magick mogrify -fill "#${config.colorscheme.palette.base0D}" -colorize 100% -path ~/.cache/tin/icons *.png
      '';
    };
  };
}
