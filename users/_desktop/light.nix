{ config, pkgs, lib, ... }:

{
  home.packages = [
  ];

  modules = {
    scripts = {
    };
    programs = {
      neovim.enable     = true;
    };
  };
}
