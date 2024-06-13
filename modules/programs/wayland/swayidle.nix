{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.wayland.swayidle;
in
{
  options.modules.programs.wayland.swayidle.enable = lib.mkEnableOption "swayidle module";

  config = lib.mkIf cfg.enable {
    services.swayidle =
      let 
        # lock_cmd = "${pkgs.swaylock-effects}/bin/swaylock -fF --color 0000ff --ring-color aaaaaa --key-hl-color dddddd -l";
        lock_cmd = lib.strings.concatStringsSep " " [
          "${pkgs.swaylock}/bin/swaylock"
          # "--screenshots"
          # "--effect-blur 7x5"
          # "--fade-in 0.5"
          # "--font 'Hack Nerd Font'"
          # "--clock"
          # "--indicator"
          "--daemonize"
          "--color ${config.colorscheme.colors.base01}"

          "--key-hl-color ${config.colorscheme.colors.base0D}"   # color of line that shows on keypress
          "--separator-color 00000000"                           # color of border of line that shows on keypress
          "--bs-hl-color ${config.colorscheme.colors.base08}"    # color of line that shows on backspace

          "--text-color ${config.colorscheme.colors.base0D}"     # color of text
          "--ring-color 00000000"                                # color of ring
          "--line-color ${config.colorscheme.colors.base0D}"     # color of ring border
          "--inside-color ${config.colorscheme.colors.base02}aa" # color of fill circle

          "--text-ver-color ${config.colorscheme.colors.base0C}"
          "--ring-ver-color 00000000"
          "--line-ver-color ${config.colorscheme.colors.base0C}"
          "--inside-ver-color ${config.colorscheme.colors.base02}aa"

          "--text-wrong-color ${config.colorscheme.colors.base08}"
          "--ring-wrong-color 00000000"
          "--line-wrong-color ${config.colorscheme.colors.base08}"
          "--inside-wrong-color ${config.colorscheme.colors.base02}aa"

          "--text-clear-color ${config.colorscheme.colors.base0A}"
          "--ring-clear-color 00000000"
          "--line-clear-color ${config.colorscheme.colors.base0A}"
          "--inside-clear-color ${config.colorscheme.colors.base02}aa"

          "--text-caps-lock-color ${config.colorscheme.colors.base09}"
          "--ring-caps-lock-color 00000000"
          "--line-caps-lock-color ${config.colorscheme.colors.base09}"
          "--inside-caps-lock-color ${config.colorscheme.colors.base02}aa"
        ];
        dpms_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms";
      in {
        enable = true;
        systemdTarget = "hyprland-session.target";
        timeouts = [
          { timeout = 300; command = lock_cmd; }
          { timeout = 600; command = "${dpms_cmd} off"; resumeCommand = "${dpms_cmd} on"; }
        ];
        events = [
          { event = "before-sleep"; command = lock_cmd; }
          { event = "lock"; command = lock_cmd; }
        ];
      };
  };
}
