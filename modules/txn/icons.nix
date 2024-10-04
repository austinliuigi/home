{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.txn.icons;
in
{
  options.modules.txn.icons.enable = lib.mkEnableOption "txn's icons module";

  config = lib.mkIf cfg.enable {
    home.file = {
      ".local/share/txn/icons".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.txn}/.local/share/txn/icons";

      ".cache/palette.dummy".onChange = ''
        echo "txn: generating icons"

        cd ~/.local/share/txn/icons
        mkdir -p ~/.cache/txn/icons && ${pkgs.imagemagick}/bin/magick mogrify -fill "#${config.colorscheme.palette.base0D}" -colorize 100% -path ~/.cache/txn/icons *.png
      '';
    };
  };
}
