{ config, pkgs, lib, ... }:

let
  cfg = config.modules.scripts.battery;

  dependencies = [
    pkgs.acpi
    pkgs.coreutils
    pkgs.gnugrep
    pkgs.libnotify
  ];

  battery = pkgs.writeShellScriptBin "battery" (''
    PATH="${lib.makeBinPath dependencies}:$PATH"
  '' + builtins.readFile "${config.scripts.battery}");
in
{
  options.modules.scripts.battery.enable = lib.mkEnableOption "battery script";

  config = lib.mkIf cfg.enable {
    modules.txn.icons.enable = true;
    home.packages = dependencies;
    home.file = {
      "scripts/battery".source = config.lib.file.mkOutOfStoreSymlink "${config.scripts.battery}";
      ".local/bin/battery".source = config.lib.file.mkOutOfStoreSymlink "${config.scripts.battery}";
    };

    systemd.user.services = {
      battery = {
        Unit = {
          Description = "Service to run battery script";
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${battery}/bin/battery";
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
