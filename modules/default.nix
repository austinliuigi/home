{ config, pkgs, ... }:

{
  imports = [
    ./scripts
    ./neovim.nix
  ];
}
