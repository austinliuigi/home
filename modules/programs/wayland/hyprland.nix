{
  pkgs,
  lib,
  config,
  inputs,
  utils,
  ...
}: let
  cfg = config.modules.programs.wayland.hyprland;
in {
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

      configType = "lua";
      extraConfig = ''
        -- source = ${config.home.homeDirectory}/.config/hypr/hyprland/settings.conf
        -- source = ${config.home.homeDirectory}/.config/hypr/hyprland/keybinds.conf
        -- source = ${config.home.homeDirectory}/.config/hypr/hyprland/gestures.conf
        -- source = ${config.home.homeDirectory}/.config/hypr/hyprland/rules.conf
        -- source = ${config.home.homeDirectory}/.config/hypr/hyprland/initialize.conf

        require("hyprland.animations")
        require("hyprland.environment_variables")
        require("hyprland.events")
        require("hyprland.gestures")
        require("hyprland.keybinds")
        require("hyprland.monitors")
        require("hyprland.options")
        require("hyprland.window_rules")
      '';
    };

    home.file = {
      ".local/share/hyprland/palette.lua" = {
        text = config.configuration.interpolateConfigFileWithMsg {
          file = "${config.dotfiles.hyprland}/.local/share/hyprland/palette.lua";
          comment_start = "--";
        };
        onChange = ''
          echo "hyprland: reloading config"
          ${pkgs.hyprland}/bin/hyprctl reload >/dev/null
        '';
      };

      ".local/share/hyprland/palette.conf" = {
        text = config.configuration.interpolateConfigFileWithMsg {
          # file = "${config.dotfiles.hyprland}/.local/share/hyprland/palette.lua";
          # comment_start = "--";
          file = "${config.dotfiles.hyprland}/.local/share/hyprland/palette.conf";
          comment_start = "#";
        };
      };

      ".local/share/hyprland/scripts".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.hyprland}/.local/share/hyprland/scripts";
      ".config/hypr/hyprland".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.hyprland}/.config/hypr/hyprland";
    };
  };
}
