{ config, pkgs, lib, ... }:

{
  home.packages = [
  ];

  modules = {
    scripts.enable = true;
    programs = {
      neovim.enable     = true;
    };
  };
}
