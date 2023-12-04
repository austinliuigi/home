{ config, pkgs, lib, ... }:

let
  cfg = config.modules.scripts.wayland.screenshot;

  PATH = lib.strings.concatStringsSep ":" [
    "${pkgs.fd}/bin"
    "${pkgs.grim}/bin"
    "${pkgs.slurp}/bin"
    "${pkgs.rofi-wayland}/bin"
    "${pkgs.wl-clipboard}/bin"
    "${pkgs.libnotify}/bin"
  ];

  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    PATH="${PATH}:$PATH"

    function exit_if_error() {
        if [ "$?" == 1 ]; then
            echo "$1" >&2
            exit
        fi
    }

    function notify() {
        echo "Screenshot saved to $1"

        notify-send --urgency=normal --icon="$HOME/.cache/tin/icons/image.png" "Screenshot" "Saved to $1"
    }

    dir="$(echo -e "clipboard\n$(fd . ~ --type=d)" | rofi -dmenu -p '(Directory or clipboard)')"
    exit_if_error "screenshot cancelled"

    if [ "$dir" == "clipboard" ]; then
        grim -t png -g "$(slurp -d)" - | wl-copy -t image/png
        exit_if_error "screenshot cancelled"

        notify "$dir"
    else
        filename="$(rofi -dmenu -p "(Filename) $dir")"
        exit_if_error "screenshot cancelled"

        filepath="''${dir}''${filename}"
        grim -t png -g "$(slurp -d)" "$filepath"
        exit_if_error "screenshot cancelled"

        notify "$filepath"
    fi
  '';
in
{
  options.modules.scripts.wayland.screenshot.enable = lib.mkEnableOption "screenshot script";

  config = lib.mkIf cfg.enable {
    modules.tin.icons.enable = true;
    home.packages = [ screenshot ];
  };
}
