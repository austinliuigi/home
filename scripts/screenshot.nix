{ pkgs }:

let
  grim = "${pkgs.grim}/bin/grim";
  slurp = "${pkgs.slurp}/bin/slurp";
  rofi = "${pkgs.rofi-wayland}/bin/rofi";
  wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
in
  pkgs.writeShellScriptBin "screenshot" ''
    function exit_if_error() {
        if [ "$?" == 1 ]; then
            echo "$1"
            exit
        fi
    }

    dir="$(echo -e "clipboard\n$(fd . ~ --type=d)" | ${rofi} -dmenu -p '(Directory or clipboard)')"
    exit_if_error "screenshot cancelled"

    if [ "''${dir}" == "clipboard" ]; then
        ${grim} -t png -g "$(${slurp} -d)" - | ${wl-copy} -t image/png
        echo "screenshot saved to clipboard"
    else
        filename="$(rofi -dmenu -p "(Filename) ''${dir}")"
        exit_if_error "screenshot cancelled"
        filepath="''${dir}''${filename}"
        ${grim} -t png -g "$(${slurp} -d)" "''${filepath}"
        echo "screenshot saved to ''${filepath}"
    fi
  ''
