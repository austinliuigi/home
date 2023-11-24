{ config, pkgs, lib, ... }:

{
  # options.dotfiles = lib.mkOption {
  #   type = lib.types.str;
  #   readOnly = true;
  #   default = "${config.home.homeDirectory}/.config/home-manager/users/austin/dotfiles";
  #   description = ''
  #     Path to dotfiles directory
  #   '';
  # };

  imports = [
    ../_base
  ];

  config = {
    # Metadata that home manager needs
    home.username = "austin";
    home.homeDirectory = "/home/austin";

    modules = {
      bundles = {
        desktop_light.enable = true;
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
