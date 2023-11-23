{ config, pkgs, lib, ... }:

{
  config = {
    # Packages to install for this user
    home.packages = [
    ];

    # Custom modules to enable for this user
    modules = {
      scripts.enable = true;
      programs = {
        neovim.enable     = true;
      };
    };
  };
}
