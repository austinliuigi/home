{ config, pkgs, lib, utils, inputs, ... }:

{
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  config = {
    # https://github.com/tinted-theming/base16-schemes
    colorscheme = inputs.nix-colors.colorschemes.gruvbox-dark-medium;

    home.file = {
      ".cache/palette.dummy".text = ''
        # this is a dummy file used to detect a colorscheme change in nix
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
      substitutions = config.colorscheme.colors // {
        transparent = transparent;
        opacity_ratio = opacity_ratio;
        opacity_percentage = opacity_percentage;
      };
    };
  };
}
