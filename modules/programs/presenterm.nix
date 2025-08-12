{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.programs.presenterm;
in {
  options.modules.programs.presenterm.enable = lib.mkEnableOption "presenterm module";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.presenterm];

    home.file = {
      ".config/presenterm".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.presenterm}/.config/presenterm";
      ".local/share/presenterm/palette.yaml".text = config.configuration.interpolateConfigFileWithMsg {
        file = "${config.dotfiles.presenterm}/.local/share/presenterm/palette.yaml";
        comment_start = "#";
      };
      ".local/share/presenterm/palette.tmTheme".text = config.configuration.interpolateConfigFileWithMsg {
        file = "${config.dotfiles.presenterm}/.local/share/presenterm/palette.tmTheme";
        comment_start = "<!--";
        comment_end = "-->";
      };
    };
    home.activation = {
      # - presenterm only correctly adds user themes in $XDG_CONFIG_DIR/presenterm/themes/; themes in other directories will not load
      # - we link to the interpolated palette theme during activation so that the home directory is not hardcoded in the symlink
      # - creating a relative symlink to the interpolated palette can be misleading because it would be relative to
      #   ~/.config/home-manager/<user>/dotfiles/presenterm/.config/themes instead of ~/.config/presenterm/themes
      presentermLinkTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
        run ln -f -s $VERBOSE_ARG "$HOME/.local/share/presenterm/palette.yaml" "$HOME/.config/presenterm/themes/palette.yaml" || true
        run ln -f -s $VERBOSE_ARG "$HOME/.local/share/presenterm/palette.tmTheme" "$HOME/.config/presenterm/themes/highlighting/palette.tmTheme" || true
      '';
    };
  };
}
