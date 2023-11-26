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

    # xdg.configFile = utils.interpolateConfigDirWithMsg { dir = "${/. + "${config.dotfiles.sioyek}/.config"}"; comment_start = "#"; };
    xdg.configFile = {
      "sioyek/prefs_user.config" = utils.interpolateConfigFileWithMsg { file = "${/. + "${config.dotfiles.sioyek}/.config/sioyek/prefs_user.config"}"; comment_start = "#"; };
      "sioyek/keys_user.config".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.sioyek}/.config/sioyek/keys_user.config";
    };
  };
}
