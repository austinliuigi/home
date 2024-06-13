{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.wezterm;
in
{
  options.modules.programs.wezterm.enable = lib.mkEnableOption "wezterm module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.wezterm ];

    home.file = {
      ".local/share/wezterm/palette.lua" = {
        text = config.configuration.interpolateConfigFileWithMsg { file = "${config.dotfiles.wezterm}/.local/share/wezterm/palette.lua"; comment_start = "--"; };
        onChange = ''
          procs=$(${pkgs.busybox}/bin/pgrep wezterm || true)
          if [ -n "$procs" ]; then
            echo "wezterm: reloading config"
            touch "${config.dotfiles.wezterm}/.config/wezterm/wezterm.lua"
          fi
        '';
      };

      ".local/share/wezterm/font.lua" = {
        text = config.configuration.interpolateConfigFileWithMsg { file = "${config.dotfiles.wezterm}/.local/share/wezterm/font.lua"; comment_start = "--"; };
        onChange = ''
          procs=$(${pkgs.busybox}/bin/pgrep wezterm || true)
          if [ -n "$procs" ]; then
            echo "wezterm: reloading config"
            touch "${config.dotfiles.wezterm}/.config/wezterm/wezterm.lua"
          fi
        '';
      };

      ".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.wezterm}/.config/wezterm";
    };
  };
}
