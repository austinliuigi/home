{ config, pkgs, lib, ... }:

let
  cfg = config.modules.bundles.desktop_light;
in
{
  options.modules.bundles.desktop_light.enable = lib.mkEnableOption "desktop bundle module";

  config = lib.mkIf cfg.enable {
    # Packages to install for this user
    home.packages = [
    ];

    # Custom modules to enable for this user
    modules = {
      scripts.enable = true;
      programs = {
        neovim.enable     = true;
      };
    };
  };
}
