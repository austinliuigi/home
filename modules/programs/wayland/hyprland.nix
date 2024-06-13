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
      # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      # plugins = [
      #   inputs.hyprland-plugins.packages.${pkgs.system}.borders-plus-plus
      # ];
      extraConfig = ''
      source = ${config.home.homeDirectory}/.config/hypr/hyprland/settings.conf
      source = ${config.home.homeDirectory}/.config/hypr/hyprland/keybinds.conf
      source = ${config.home.homeDirectory}/.config/hypr/hyprland/rules.conf
      source = ${config.home.homeDirectory}/.config/hypr/hyprland/initialize.conf
      '';
    };

    home.file = {
      ".local/share/hyprland/palette.conf" = {
        text = config.configuration.interpolateConfigFileWithMsg { file = "${config.dotfiles.hyprland}/.local/share/hyprland/palette.conf"; comment_start = "#"; };
        onChange = ''
          echo "hyprland: reloading config"
          ${pkgs.hyprland}/bin/hyprctl reload >/dev/null
        '';
      };
      ".local/share/hyprland/scripts".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.hyprland}/.local/share/hyprland/scripts";
      ".config/hypr/hyprland".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.hyprland}/.config/hypr/hyprland";
    };
  };
}
