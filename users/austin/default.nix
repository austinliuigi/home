{ config, pkgs, lib, ... }:

{
  options.dotfiles = lib.mkOption {
    type = lib.types.str;
    readOnly = true;
    default = "${config.home.homeDirectory}/.config/home-manager/users/austin/dotfiles";
    description = ''
      Path to dotfiles directory
    '';
  };

  config = {

    # Metadata that home manager needs
    home.username = "austin";
    home.homeDirectory = "/home/austin";

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
        hyprland.enable   = true;
        ios.enable        = true;
        kdeconnect.enable = true;
        lua.enable        = true;
        neovim.enable     = true;
        python.enable     = true;
        sioyek.enable     = true;
        swayidle.enable   = true;
        syncthing.enable  = true;
        texlive.enable    = true;
      };
    };

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    programs.home-manager.enable = true;  # install and manage home-manager

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "23.05"; # Please read the comment before changing.
  };
}
