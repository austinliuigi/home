{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.btop;
in
{
  options.modules.programs.btop.enable = lib.mkEnableOption "btop module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.btop ];

    home.file = {
      ".config/btop".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.btop}/.config/btop";

      ".local/share/btop/palette.theme" = {
        text = config.configuration.interpolateConfigFileWithMsg { file = "${config.dotfiles.btop}/.local/share/btop/palette.theme"; comment_start = "#"; };
      };
    };
    home.activation = {
      # btop only correctly adds user themes in $XDG_CONFIG_DIR/btop/themes/; themes in other directories will not load
      # we link to the interpolated palette theme during activation so that the hoem directory is not hardcoded in the symlink
      btopLinkTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
        run ln -f -s $VERBOSE_ARG "$HOME/.local/share/btop/palette.theme" "$HOME/.config/btop/themes/palette.theme" || true
      '';
    };
  };
}
