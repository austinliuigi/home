{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.programs.wayland.awww;
in {
  options.modules.programs.wayland.awww.enable = lib.mkEnableOption "awww module";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.awww];

    modules.txn.wallpaper.enable = true;

    home.file = {
      ".cache/palette.dummy".onChange = lib.mkAfter ''
        echo "awww: updating wallpaper"

        ${pkgs.awww}/bin/awww img --transition-type center ~/.cache/txn/wallpaper.png || true
      '';
    };
    # home.activation = {
    #   wallpaper = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #     if [ ! -d ~/wallpapers ]; then $DRY_RUN_CMD mkdir $VERBOSE_ARG ~/wallpapers; fi
    #     $DRY_RUN_CMD ${pkgs.imagemagick}/bin/convert ${config.dotfiles._wallpapers}/wallpaper.png -fill \#${config.colorscheme.colors.base02} -tint 100 ~/wallpapers/wallpaper.png 2> /dev/null
    #     ${pkgs.awww}/bin/awww img ~/wallpapers/wallpaper.png
    #   '';
    # };
  };
}
