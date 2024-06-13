{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.wayland.hypridle;
in
{
  options.modules.programs.wayland.hypridle.enable = lib.mkEnableOption "hypridle module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.hypridle ];

    home.file = {
      ".config/hypr/hypridle.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.hypridle}/.config/hypr/hypridle.conf";
    };

    systemd.user.services.hypridle = {
      Unit = {
        Description = "Hypridle";
        After = ["graphical-session.target"];
      };

      Service = {
        # execute using bash so that it inherits the environment, o.w. binaries that are run in the config won't be found
        #   - https://unix.stackexchange.com/questions/675521/make-systemd-service-inherit-environment-variables-from-etc-profile-d
        ExecStart = "${pkgs.bash}/bin/bash -lc '${pkgs.hypridle}/bin/hypridle'";
        Restart = "always";
        RestartSec = "10";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
