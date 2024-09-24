{ config, pkgs, lib, utils, inputs, ... }:

{
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  config = {
    # https://github.com/tinted-theming/schemes
    colorscheme = inputs.nix-colors.colorschemes.base16.nord;
    # colorScheme = {
      # slug = "custom";
      # name = "Custom";
      # author = "Austin Liu";
      # palette = {
        # base00 = "#101010"; # ----
        # base01 = "#252525"; # ---
        # base02 = "#464646"; # --
        # base03 = "#525252"; # -
        # base04 = "#ababab"; # +
        # base05 = "#b9b9b9"; # ++
        # base06 = "#e3e3e3"; # +++
        # base07 = "#f7f7f7"; # ++++
        # base08 = "#e6dc44"; # red
        # base09 = "#999999"; # orange
        # base0A = "#f4fd22"; # yellow
        # base0B = "#c8be46"; # green
        # base0C = "#868686"; # cyan
        # base0D = "#686868"; # blue
        # base0E = "#747474"; # purple
        # base0F = "#5e5e5e"; # brown
        # base10 = "#1b1d1e"; # -----
        # base11 = "#1b1d1e"; # ------
        # base12 = "#e6dc44"; # bright red
        # base13 = "#f4fd22"; # bright yellow
        # base14 = "#c8be46"; # bright green
        # base15 = "#fcef0c"; # bright cyan
        # base16 = "#fff27d"; # bright blue
        # base17 = "#fff78e"; # bright purple
      # };
    # };

    home.file = {
      ".cache/palette.dummy".text = ''
        # this is a dummy file used to detect a palette change in nix
        ${config.colorscheme.name}
      '';
    };

    # config.colorscheme defined at https://github.com/Misterio77/nix-colors/blob/main/module/colorscheme.nix
    configuration =
    let
      transparent = "false";
      opacity = 0.8;
      opacity_ratio = if transparent == "true" then lib.strings.floatToString opacity else "1.0";
      opacity_percentage = if transparent == "true" then builtins.toString (opacity * 100) else "100";
    in
    {
      substitutions = config.colorscheme.palette // {
        transparent = transparent;
        opacity_ratio = opacity_ratio;
        opacity_percentage = opacity_percentage;
      };
    };
  };
}
