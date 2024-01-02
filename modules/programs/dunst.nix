{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.dunst;
in
{
  options.modules.programs.dunst.enable = lib.mkEnableOption "dunst module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.dunst pkgs.libnotify ];

    home.file = {
      ".config/dunst".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.dunst}/.config/dunst";

      ".local/share/dunst/palette" = {
        text = config.configuration.interpolateConfigFileWithMsg { file = "${config.dotfiles.dunst}/.local/share/dunst/palette"; comment_start = "#"; };
        onChange = ''
          procs=$(${pkgs.busybox}/bin/pgrep dunst || true)
          if [ -n "$procs" ]; then
            echo "dunst: reloading config"
            kill $procs
          fi
        '';
      };
    };

    xdg.dataFile."dbus-1/services/org.knopwob.dunst.service".source =
      "${pkgs.dunst}/share/dbus-1/services/org.knopwob.dunst.service";

    systemd.user.services.dunst = {
      Unit = {
        Description = "Dunst notification daemon";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "dbus";
        BusName = "org.freedesktop.Notifications";
        ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/cat /home/austin/.config/dunst/dunstrc /home/austin/.local/share/dunst/palette | ${pkgs.dunst}/bin/dunst -config -'";
      };
    };
  };
}
