{ pkgs, lib, config, inputs, utils, ... }:

let
  cfg = config.modules.programs.sioyek;
in
{
  options.modules.programs.sioyek.enable = lib.mkEnableOption "sioyek module";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.sioyek
    ];

    home.file = {
      ".local/share/sioyek/palette.config" = {
        text = config.configuration.interpolateConfigFileWithMsg { file = "${config.dotfiles.sioyek}/.local/share/sioyek/palette.config"; comment_start = "#"; };
        onChange = ''
          procs=$(${pkgs.busybox}/bin/pgrep sioyek || true)
          if [ -n "$procs" ]; then
            echo "sioyek: reloading config"
            touch "${config.dotfiles.sioyek}/.config/sioyek/prefs_user.config"
          fi
        '';
      };
      ".config/sioyek".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.sioyek}/.config/sioyek";
    };
  };
}
