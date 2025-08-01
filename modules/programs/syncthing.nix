# NOTE: we configure syncthing using nix becuase:
#  - the config file isn't meant to be able to work across multiple machines since every device is unique in syncthing
#  - the config file contains secrets, such as the REST API key
{
  pkgs,
  lib,
  config,
  inputs,
  hostname,
  ...
}: let
  cfg = config.modules.programs.syncthing;
  hub = "cloudlab"; # the server that acts as the central hub in my cluster

  #===================================================================================================
  # DEVICES
  # - any [syncthing device configuration parameters](https://docs.syncthing.net/v1.29.3/users/config.html#device-element) can be put here
  #   - types are defined [here](https://github.com/syncthing/syncthing/blob/main/lib/config/deviceconfiguration.go)
  #   - you can also see an example json configuration by querying an existing syncthing instance, e.g. `curl -X GET -H "X-API-Key: <API_KEY>" http://localhost:8384/rest/config/devices/UNUYF5C-Q5K4AGX-FCBNG35-ET3W2YN-TYFDGVG-WQNGWDN-EOE66R3-WTOR7QH`
  #===================================================================================================
  deviceBase = {
    autoAcceptFolders = false;
  };

  devices = lib.mapAttrs (name: value: deviceBase // value) {
    cloudlab = {
      id = "ST7U3RW-RE6UF3O-72N57KP-C54CPWS-B2ZTCVP-TTM47LW-447V7IP-36SVBQC";
    };
    x1-carbon = {
      id = "UNUYF5C-Q5K4AGX-FCBNG35-ET3W2YN-TYFDGVG-WQNGWDN-EOE66R3-WTOR7QH";
    };
    m1-macbook-air = {
      id = "INADG3A-GATQUGJ-GHNIWTK-32LQDID-DGWB36R-CZJNZPS-JPJI36C-BSNJKQL";
    };
    ghost-s1 = {
      id = "2DWIXMI-ALEUPVJ-NR344RT-RIIBG6E-JLT4ABC-Y6JW23K-WWH3L67-VURIGAC";
    };
    phone = {
      id = "DSL3FCT-A44MBOJ-MJBRQDO-5Y2V2QY-NMS3YQJ-OIL5GYV-OBAXMB3-NE7OQAM";
    };
  };

  #===================================================================================================
  # FOLDERS
  # - any [syncthing folder configuration parameters](https://docs.syncthing.net/v1.29.3/users/config.html#folder-element) can be put here
  #   - types are defined [here](https://github.com/syncthing/syncthing/blob/main/lib/config/folderconfiguration.go)
  #   - you can also see an example json configuration by querying an existing syncthing instance, e.g. `curl -X GET -H "X-API-Key: <API_KEY>" http://localhost:8384/rest/config/folders/pypev-zfwnm`
  #===================================================================================================
  folderBase = {
    enable = true;
    devices =
      if (hostname == hub)
      then builtins.attrNames (builtins.removeAttrs devices [hub])
      else [hub];
    rescanIntervalS = 1800;
  };

  folders = lib.mapAttrs (name: value: folderBase // value) {
    "backlog" = {
      id = "dgzrv-myjtx";
      path = "${config.home.homeDirectory}/backlog";
    };
    "cookbook" = {
      id = "7tnly-dyrts";
      path = "${config.home.homeDirectory}/cookbook";
    };
    "checklists" = {
      id = "jnvdc-tncl6";
      path = "${config.home.homeDirectory}/checklists";
    };
    "todo" = {
      id = "mwxtf-jm7w5";
      path = "${config.home.homeDirectory}/todo";
    };
    "guides" = {
      id = "rpect-q9ay6";
      path = "${config.home.homeDirectory}/guides";
    };
    "jobs" = {
      id = "bbnen-rjqm5";
      path = "${config.home.homeDirectory}/jobs";
    };
    "notes" = {
      id = "pypev-zfwnm";
      path = "${config.home.homeDirectory}/notes";
    };
    "scratchpad" = {
      id = "s4ykd-trtwt";
      path = "${config.home.homeDirectory}/scratchpad";
    };
    "textbooks" = {
      enable = false;
      id = "477wq-kdsru";
      path = "${config.home.homeDirectory}/textbooks";
    };
  };
in {
  options.modules.programs.syncthing = {
    enable = lib.mkEnableOption "syncthing module";
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      guiAddress = "127.0.0.1:8384"; # this is both generic and secure, but requires ssh tunneling to access the gui for headless servers, e.g. `ssh -N -L :8080:localhost:8384 cloudlab`
      settings = {
        devices =
          if (hostname == hub)
          then builtins.removeAttrs devices [hub]
          else {${hub} = devices.${hub} // {introducer = true;};};
        folders = folders;
      };
    };
  };
}
