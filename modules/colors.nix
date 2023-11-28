{ config, pkgs, lib, utils, inputs, ... }:

{
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  config = {
    # https://github.com/tinted-theming/base16-schemes
    colorscheme = inputs.nix-colors.colorschemes.nord;

    # config.colorscheme defined at https://github.com/Misterio77/nix-colors/blob/main/module/colorscheme.nix
    configuration =
    let
      transparent = "false";
      opacity_ratio = if transparent == "true" then "0.0" else "1.0";
      opacity_percentage = if transparent == "true" then "0" else "100";
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
