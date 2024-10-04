{ config, pkgs, lib, ... }:

let
  cfg = config.modules.scripts.battery;

  PATH = lib.strings.concatStringsSep ":" [
    "${pkgs.acpi}/bin"
    "${pkgs.gnugrep}/bin"
    "${pkgs.libnotify}/bin"
    "${pkgs.coreutils}/bin"
  ];

  battery = pkgs.writeShellScript "battery" ''
    PATH="${PATH}:$PATH"

    battery="$(acpi --battery | grep -Po '\d+(?=%)')"

    function notify() {
        icon="$HOME/.cache/txn/icons/battery.png"
        notify-send --urgency=critical --icon="$icon" --hint=int:value:"$battery" "Battery" "$battery"
    }

    mkdir -p "$HOME/.local/state/battery"
    if [ ! -f "$HOME/.local/state/battery/percentage" ]; then
      echo "$battery" > "$HOME/.local/state/battery/percentage"
    fi

    prev_battery="$(cat "$HOME/.local/state/battery/percentage")"

    if [ "$battery" -le 3 ] && [ "$prev_battery" -gt 3 ]; then
      systemctl hibernate
    elif ([ "$battery" -le 5 ] && [ "$prev_battery" -gt 5 ]) \
      || ([ "$battery" -le 10 ] && [ "$prev_battery" -gt 10 ]) \
      || ([ "$battery" -le 20 ] && [ "$prev_battery" -gt 20 ]) \
    then
      notify
    fi

    echo "$battery" > "$HOME/.local/state/battery/percentage"
  '';
in
{
  options.modules.scripts.battery.enable = lib.mkEnableOption "battery script";

  config = lib.mkIf cfg.enable {
    modules.txn.icons.enable = true;

    systemd.user.services = {
      battery = {
        Unit = {
          Description = "Service to run battery script";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${battery}";
        };
        Install.WantedBy = [ "default.target" ];
      };
    };

    systemd.user.timers = {
      battery = {
        Unit = {
          Description = "Timer for battery service";
        };
        Timer = {
          Unit = "battery.service";
          OnCalendar = "*:00/2:00";
          Persistent = "false";
        };
        Install.WantedBy = [ "timers.target" ];
      };
    };
  };
}
