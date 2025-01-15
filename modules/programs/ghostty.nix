{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.ghostty;
in
{
  options.modules.programs.ghostty.enable = lib.mkEnableOption "ghostty module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.ghostty ];

    home.file = {
      ".local/share/ghostty/palette.config" = {
        text = config.configuration.interpolateConfigFileWithMsg { file = "${config.dotfiles.ghostty}/.local/share/ghostty/palette.config"; comment_start = "#"; };
        # onChange = ''
        #   procs=$(${pkgs.busybox}/bin/pgrep ghostty || true)
        #   if [ -n "$procs" ]; then
        #     echo "ghostty: reloading config"
        #     kill -SIGUSR1 $procs
        #   fi
        # '';
      };

      ".local/share/ghostty/font.config" = {
        text = config.configuration.interpolateConfigFileWithMsg { file = "${config.dotfiles.ghostty}/.local/share/ghostty/font.config"; comment_start = "#"; };
        # onChange = ''
        #   procs=$(${pkgs.busybox}/bin/pgrep ghostty || true)
        #   if [ -n "$procs" ]; then
        #     echo "ghostty: reloading config"
        #     kill -SIGUSR1 $procs
        #   fi
        # '';
      };

      ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.ghostty}/.config/ghostty";
    };
  };
}
