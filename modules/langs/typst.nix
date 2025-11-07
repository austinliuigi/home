{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.langs.typst;
in {
  options.modules.langs.typst = {
    enable = lib.mkEnableOption "typst module";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.typst
      pkgs.typstyle
      pkgs.tinymist
    ];

    home.file = {
      ".local/share/typst/packages".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.typst}/.local/share/typst/packages";
    };
  };
}
