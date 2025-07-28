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
  devices = {
    cloudlab = {
      id = "ST7U3RW-RE6UF3O-72N57KP-C54CPWS-B2ZTCVP-TTM47LW-447V7IP-36SVBQC";
      # autoAcceptFolders = true;
    };
    x1-carbon = {
      id = "UNUYF5C-Q5K4AGX-FCBNG35-ET3W2YN-TYFDGVG-WQNGWDN-EOE66R3-WTOR7QH";
      # autoAcceptFolders = true;
    };
    m1-macbook-air = {
      id = "INADG3A-GATQUGJ-GHNIWTK-32LQDID-DGWB36R-CZJNZPS-JPJI36C-BSNJKQL";
      # autoAcceptFolders = true;
    };
    ghost-s1 = {
      id = "2DWIXMI-ALEUPVJ-NR344RT-RIIBG6E-JLT4ABC-Y6JW23K-WWH3L67-VURIGAC";
      # autoAcceptFolders = true;
    };
    phone = {
      id = "DSL3FCT-A44MBOJ-MJBRQDO-5Y2V2QY-NMS3YQJ-OIL5GYV-OBAXMB3-NE7OQAM";
      # autoAcceptFolders = true;
    };
  };
  folderBase = {
    devices =
      if (hostname == hub)
      then builtins.AttrNames (builtins.removeAttrs devices [hub])
      else [hub];
    # versioning = {
    #   type = "";
    #   params = {
    #   };
    # };
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
          else builtins.removeAttrs devices (lib.lists.remove hub (builtins.attrNames devices));
        folders = {
          "backlog" =
            {
              enable = true;
              id = "dgzrv-myjtx";
              path = "${config.home.homeDirectory}/backlog";
            }
            // folderBase;
          "cookbook" =
            {
              enable = true;
              id = "7tnly-dyrts";
              path = "${config.home.homeDirectory}/cookbook";
            }
            // folderBase;
          "gtd" =
            {
              enable = true;
              id = "mwxtf-jm7w5";
              path = "${config.home.homeDirectory}/gtd";
            }
            // folderBase;
          "guides" =
            {
              enable = true;
              id = "rpect-q9ay6";
              path = "${config.home.homeDirectory}/guides";
            }
            // folderBase;
          "jobs" =
            {
              enable = true;
              id = "bbnen-rjqm5";
              path = "${config.home.homeDirectory}/jobs";
            }
            // folderBase;
          "notes" =
            {
              enable = true;
              id = "pypev-zfwnm";
              path = "${config.home.homeDirectory}/notes";
            }
            // folderBase;
          "scratchpad" =
            {
              enable = true;
              id = "s4ykd-trtwt";
              path = "${config.home.homeDirectory}/scratchpad";
            }
            // folderBase;
          "textbooks" =
            {
              enable = false;
              id = "477wq-kdsru";
              path = "${config.home.homeDirectory}/textbooks";
            }
            // folderBase;
        };
      };
    };
  };
}
