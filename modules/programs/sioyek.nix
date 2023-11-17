{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.sioyek;
in
{
  options.modules.programs.sioyek.enable = lib.mkEnableOption "sioyek module";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.sioyek
    ];

    # create a symlink of the config to the proper location
    xdg.configFile = {
      sioyek.source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/sioyek/.config/sioyek";
    };
  };
}
