{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.wayland.swayidle;
in
{
  options.modules.programs.wayland.swayidle.enable = lib.mkEnableOption "swayidle module";

  config = lib.mkIf cfg.enable {
    services.swayidle =
      let 
        lock_cmd = "${pkgs.swaylock}/bin/swaylock -fF --color 0000ff --ring-color aaaaaa --key-hl-color dddddd -l";
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
