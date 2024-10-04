{ config, pkgs, lib, ... }:

let
  cfg = config.modules.scripts.volume;

  PATH = lib.strings.concatStringsSep ":" [
    "${pkgs.pamixer}/bin"
    "${pkgs.libnotify}/bin"
  ];

  volume = pkgs.writeShellScriptBin "volume" ''
    PATH="${PATH}:$PATH"

    control="$1"

    function notify() {
        volume="$(pamixer --get-volume)"

        if [ "$(pamixer --get-mute)" == "true" ]; then
            icon="$HOME/.cache/txn/icons/volume-muted.png"
        else
            if [ $volume -ge 80 ]; then
                icon="$HOME/.cache/txn/icons/volume-high.png"
            elif [ $volume -ge 40 ]; then
                icon="$HOME/.cache/txn/icons/volume-medium.png"
            else
                icon="$HOME/.cache/txn/icons/volume-low.png"
            fi

        fi

        echo "Volume is $volume"

        notify-send --replace-id=4498 --urgency=low --icon="$icon" --hint=int:value:"$volume" "Volume" "$volume"
    }

    case "$control" in
        increase)
            pamixer --increase 5 --allow-boost --set-limit 150
            ;;

        decrease)
            pamixer --decrease 5 --allow-boost
            ;;

        mute)
            pamixer --toggle-mute
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
  options.modules.scripts.volume.enable = lib.mkEnableOption "volume script";

  config = lib.mkIf cfg.enable {
    modules.txn.icons.enable = true;
    home.packages = [ volume ];
  };
}
