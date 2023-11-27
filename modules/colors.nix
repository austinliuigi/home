{ config, pkgs, lib, utils, inputs, ... }:

{
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ];

  config = {
    colorscheme = inputs.nix-colors.colorschemes.gruvbox-dark-medium;

    # config.colorscheme defined at https://github.com/Misterio77/nix-colors/blob/main/module/colorscheme.nix
    configuration = {
      substitutions = config.colorscheme.colors;
    };
  };
}
