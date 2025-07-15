{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.wayland.pyprland;
in
{
  options.modules.programs.wayland.pyprland.enable = lib.mkEnableOption "pyprland module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.pyprland ];

    home.file = {
      ".config/hypr/pyprland.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.pyprland}/.config/hypr/pyprland.toml";
    };
  };
}
