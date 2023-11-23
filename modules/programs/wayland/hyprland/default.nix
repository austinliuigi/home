{ pkgs, lib, config, inputs, utils, ... }:

let
  cfg = config.modules.programs.hyprland;
in
{
  options.modules.programs.hyprland.enable = lib.mkEnableOption "hyprland module";

  config = lib.mkIf cfg.enable {
    # xdg.configFile = utils.interpolateConfig "${/. + "${config.dotfiles}/hyprland"}";

    # Manage configuration for hyprland
    # - this adds systemd support -> graphical-session.target gets run
    #     - this is needed for some gui systemd reliant programs, e.g. kdeconnect
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = ''
      source = ${config.dotfiles}/hyprland/.config/hypr/hyprland/settings.conf
      source = ${config.dotfiles}/hyprland/.config/hypr/hyprland/keybinds.conf
      source = ${config.dotfiles}/hyprland/.config/hypr/hyprland/rules.conf
      exec-once = waybar & hyprpaper &
      '';
    };

    # Add scripts that config depends on
    home.packages = [
      (import ./_swapworkspace.nix { inherit pkgs; })
      (import ./_swapmonitor.nix { inherit pkgs; })
    ];
  };
}
