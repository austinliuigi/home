{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.wayland.waybar;
in
{
  options.modules.programs.wayland.waybar.enable = lib.mkEnableOption "waybar module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.waybar ];

    home.file = {
      ".local/share/waybar/palette.css" = {
        text = config.configuration.interpolateConfigFileWithMsg { file = "${/. + "${config.dotfiles.waybar}/.local/share/waybar/palette.css"}"; comment_start = "/*"; comment_end = "*/"; };
        onChange = ''
          procs=$(${pkgs.busybox}/bin/pgrep waybar)
          if [ -n "$procs" ]; then kill $procs; fi

          PATH=${pkgs.hyprland}/bin:$PATH # wayland needs hyprctl for hyprland ipc
          ${pkgs.waybar}/bin/waybar &
        '';
      };
      ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.waybar}/.config/waybar";
    };
  };
}
