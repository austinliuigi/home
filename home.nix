{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "austin";
  home.homeDirectory = "/home/austin";

  # The home.packages nix modules option allows you to install Nix packages into your environment
  home.packages = [
    pkgs.neovim
    pkgs.zsh
    pkgs.fzf
    pkgs.nyxt
  ];

  # Manage configuration for hyprland
  # - this adds systemd support -> graphical-session.target gets run
  #     - this is needed for systemd reliant programs, e.g. kdeconnect
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    extraConfig = ''
    source = ~/.config/home-manager/configs/hyprland/settings.conf
    source = ~/.config/home-manager/configs/hyprland/keybinds.conf
    source = ~/.config/home-manager/configs/hyprland/rules.conf
    exec-once = waybar & hyprpaper &
    '';
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/configs/nvim";

  home.sessionVariables = {
    # EDITOR = "emacs";
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
}
