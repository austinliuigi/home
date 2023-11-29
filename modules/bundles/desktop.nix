{ config, pkgs, lib, ... }:

let
  cfg = config.modules.bundles.desktop;
in
{
  options.modules.bundles.desktop.enable = lib.mkEnableOption "desktop bundle module";

  config = lib.mkIf cfg.enable {
    # Packages to install for this user
    home.packages = [
      pkgs.xclip
      pkgs.deno
      pkgs.gimp
      pkgs.inkscape
      pkgs.nodejs
      pkgs.nyxt
      pkgs.pandoc
      pkgs.ttyper
      pkgs.vlc
    ];

    # Custom modules to enable for this user
    modules = {
      scripts.enable = true;
      programs = {
        c.enable          = true;
        common.enable     = true;
        core.enable       = true;
        ios.enable        = true;
        kdeconnect.enable = true;
        kitty.enable      = true;
        lua.enable        = true;
        neovim.enable     = true;
        nix.enable        = true;
        python.enable     = true;
        sioyek.enable     = true;
        syncthing.enable  = true;
        texlive.enable    = true;
        zoxide.enable     = true;
        zsh.enable        = true;
      };
    };
  };
}
