{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.foot;
in
{
  options.modules.programs.foot.enable = lib.mkEnableOption "foot module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.foot ];

    home.file = {
      ".config/foot".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.foot}/.config/foot";
      ".local/share/foot/palette.ini".text = config.configuration.interpolateConfigFileWithMsg { file = "${config.dotfiles.foot}/.local/share/foot/palette.ini"; comment_start = "#"; };
      ".local/share/foot/font.ini".text = config.configuration.interpolateConfigFileWithMsg { file = "${config.dotfiles.foot}/.local/share/foot/font.ini"; comment_start = "#"; };
    };
  };
}
