{ config, pkgs, lib, ... }:

{
  home.packages = [
  ];

  modules = {
    scripts = {
    };
    programs = {
      fonts.enable = true;
      neovim.enable = true;
    };
  };
}
