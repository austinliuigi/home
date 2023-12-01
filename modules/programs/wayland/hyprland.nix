{ pkgs, lib, config, inputs, utils, ... }:

let
  cfg = config.modules.programs.wayland.hyprland;
in
{
  options.modules.programs.wayland.hyprland.enable = lib.mkEnableOption "hyprland module";

  config = lib.mkIf cfg.enable {
    # Manage configuration for hyprland
    # - this adds systemd support -> graphical-session.target gets run
    #     - this is needed for some gui systemd reliant programs, e.g. kdeconnect
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
      source = ${config.home.homeDirectory}/.config/hypr/hyprland/settings.conf
      source = ${config.home.homeDirectory}/.config/hypr/hyprland/keybinds.conf
      source = ${config.home.homeDirectory}/.config/hypr/hyprland/rules.conf
      source = ${config.home.homeDirectory}/.local/share/hyprland/palette.conf
      source = ${config.home.homeDirectory}/.config/hypr/hyprland/initialize.conf
      '';
    };

    home.file = {
      ".local/share/hyprland/palette.conf".text = config.configuration.interpolateConfigFileWithMsg { file = "${config.dotfiles.hyprland}/.local/share/hyprland/palette.conf"; comment_start = "#"; };
      ".local/share/hyprland/scripts".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.hyprland}/.local/share/hyprland/scripts";
      ".config/hypr/hyprland".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.hyprland}/.config/hypr/hyprland";
    };
  };
}
