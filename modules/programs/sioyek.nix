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

    xdg.configFile = {
      "sioyek/prefs_user.config".text = config.configuration.interpolateConfigFileWithMsg { file = "${config.dotfiles.sioyek}/.config/sioyek/prefs_user.config"; comment_start = "#"; };
      "sioyek/keys_user.config".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.sioyek}/.config/sioyek/keys_user.config";
    };
  };
}
