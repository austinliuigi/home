{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.xdg;
in
{
  options.modules.programs.xdg.enable = lib.mkEnableOption "xdg module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.xdg-utils ];

    home.file = {
      ".config/mimeapps.list".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.xdg}/.config/mimeapps.list";
    };
  };
}
