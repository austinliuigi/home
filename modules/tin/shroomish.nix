{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.tin.shroomish;
in
{
  options.modules.tin.shroomish.enable = lib.mkEnableOption "tin's shroomish module";

  config = lib.mkIf cfg.enable {
    home.file = {
      ".local/share/tin/shroomish".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.tin}/.local/share/tin/shroomish";

      ".cache/palette.dummy".onChange = ''
        echo "tin: creating shiny shroomish"

        export PATH=${pkgs.imagemagick}/bin:${pkgs.gnumake}/bin:$PATH
        cd ~/.local/share/tin/shroomish
        make tinted COLOR="#${config.colorscheme.colors.base0D}" >/dev/null
        mkdir -p ~/.cache/tin && cp shroomish.png ~/.cache/tin/shroomish.png
        make clean >/dev/null
      '';
    };
  };
}
