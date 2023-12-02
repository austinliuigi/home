{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.wayland.swww;
in
{
  options.modules.programs.wayland.swww.enable = lib.mkEnableOption "swww module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.swww ];

    home.file = {
      "wallpapers/palette.dummy" = {
        text = ''
          # this is a dummy file used to detect a colorscheme change in nix
          ${config.colorscheme.name}
        '';
        onChange = ''
          echo "swww: generating wallpaper"

          ${pkgs.imagemagick}/bin/convert ${config.dotfiles._wallpapers}/wallpaper.png -fill \#${config.colorscheme.colors.base02} -tint 100 ~/wallpapers/wallpaper.png 2> /dev/null

          ${pkgs.swww}/bin/swww img ~/wallpapers/wallpaper.png
        '';
      };
    };
    # home.activation = {
    #   wallpaper = lib.hm.dag.entryAfter ["writeBoundary"] ''
    #     if [ ! -d ~/wallpapers ]; then $DRY_RUN_CMD mkdir $VERBOSE_ARG ~/wallpapers; fi
    #     $DRY_RUN_CMD ${pkgs.imagemagick}/bin/convert ${config.dotfiles._wallpapers}/wallpaper.png -fill \#${config.colorscheme.colors.base02} -tint 100 ~/wallpapers/wallpaper.png 2> /dev/null
    #     ${pkgs.swww}/bin/swww img ~/wallpapers/wallpaper.png
    #   '';
    # };
  };
}
