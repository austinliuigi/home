{ config, pkgs, lib, ... }:

{
  imports = [
    ../_base
    ../_desktop
    ../_desktop/environments/hyprland.nix
  ];

  config = {
    # Metadata that home manager needs
    home.username = "austin";
    home.homeDirectory = "/home/austin";

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
