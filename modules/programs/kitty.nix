{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.kitty;
in
{
  options.modules.programs.kitty.enable = lib.mkEnableOption "kitty module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.kitty ];

    home.file = {
      ".local/share/kitty/palette.conf" = {
        text = config.configuration.interpolateConfigFileWithMsg { file = "${config.dotfiles.kitty}/.local/share/kitty/palette.conf"; comment_start = "#"; };
        onChange = ''
          procs=$(${pkgs.busybox}/bin/pgrep kitty || true)
          if [ -n "$procs" ]; then
            echo "kitty: reloading config"
            kill -SIGUSR1 $procs
          fi
        '';
      };
      ".config/kitty".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.kitty}/.config/kitty";
    };
  };
}
