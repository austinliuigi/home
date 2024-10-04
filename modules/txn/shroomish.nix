{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.txn.shroomish;
in
{
  options.modules.txn.shroomish.enable = lib.mkEnableOption "txn's shroomish module";

  config = lib.mkIf cfg.enable {
    home.file = {
      ".local/share/txn/shroomish".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.txn}/.local/share/txn/shroomish";

      ".cache/palette.dummy".onChange = ''
        echo "txn: creating shiny shroomish"

        export PATH=${pkgs.imagemagick}/bin:${pkgs.gnumake}/bin:$PATH
        cd ~/.local/share/txn/shroomish
        make tinted COLOR="#${config.colorscheme.palette.base0D}" >/dev/null
        mkdir -p ~/.cache/txn && cp shroomish.png ~/.cache/txn/shroomish.png
        make clean >/dev/null
      '';
    };
  };
}
