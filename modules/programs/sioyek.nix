{ pkgs, lib, config, inputs, utils, ... }:

let
  cfg = config.modules.programs.sioyek;
in
{
  options.modules.programs.sioyek.enable = lib.mkEnableOption "sioyek module";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.sioyek
    ];

    xdg.configFile = utils.interpolateConfig "${/. + "${config.dotfiles.sioyek}/.config"}";
  };
}
