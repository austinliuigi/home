{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.programs.btop;
in {
  options.modules.programs.btop.enable = lib.mkEnableOption "btop module";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.btop];

    home.file = {
      ".config/btop".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.btop}/.config/btop";

      ".local/share/btop/palette.theme" = {
        text = config.configuration.interpolateConfigFileWithMsg {
          file = "${config.dotfiles.btop}/.local/share/btop/palette.theme";
          comment_start = "#";
        };
        onChange = ''
          procs=$(${pkgs.busybox}/bin/pgrep btop || true)
          if [ -n "$procs" ]; then
            echo "btop: sending SIGUSR2"
            kill -SIGUSR2 $procs
          fi
        '';
      };
    };
    home.activation = {
      # - btop only correctly adds user themes in $XDG_CONFIG_DIR/btop/themes/; themes in other directories will not load
      # - we link to the interpolated palette theme during activation so that the home directory is not hardcoded in the symlink
      # - creating a relative symlink to the interpolated palette can be misleading because it would be relative to
      #   ~/.config/home-manager/<user>/dotfiles/btop/.config/themes instead of ~/.config/btop/themes
      btopLinkTheme = lib.hm.dag.entryAfter ["writeBoundary"] ''
        run ln -f -s $VERBOSE_ARG "$HOME/.local/share/btop/palette.theme" "$HOME/.config/btop/themes/palette.theme" || true
      '';
    };
  };
}
