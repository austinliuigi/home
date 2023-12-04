{ config, pkgs, lib, ... }:

let
  cfg = config.modules.scripts.brightness;

  PATH = lib.strings.concatStringsSep ":" [
    "${pkgs.brightnessctl}/bin"
    "${pkgs.bc}/bin"
    "${pkgs.libnotify}/bin"
  ];

  brightness = pkgs.writeShellScriptBin "brightness" ''
    PATH="${PATH}:$PATH"

    control="$1"

    function notify() {
        brightness="$(printf "%0.0f\n" "$(echo "scale=5; $(brightnessctl get)/$(brightnessctl max) * 100" | bc)")"

        if [ $brightness -ge 75 ]; then
            icon="$HOME/.cache/tin/icons/brightness-high.png"
        elif [ $brightness -ge 45 ]; then
            icon="$HOME/.cache/tin/icons/brightness-medium.png"
        else
            icon="$HOME/.cache/tin/icons/brightness-low.png"
        fi

        echo "Brightness is $brightness"

        notify-send --replace-id=1998 --urgency=low --icon="$icon" --hint=int:value:"$brightness" "Brightness" "$brightness"
    }

    case "$control" in
        increase)
            brightnessctl set 5%+ >/dev/null
            ;;

        decrease)
            brightnessctl set 5%- >/dev/null
            ;;

        *)
            echo "usage: $0 CONTROL" >&2
            exit 1
            ;;
    esac

    notify
  '';
in
{
  options.modules.scripts.brightness.enable = lib.mkEnableOption "brightness script";

  config = lib.mkIf cfg.enable {
    modules.tin.icons.enable = true;
    home.packages = [ brightness ];
  };
}
