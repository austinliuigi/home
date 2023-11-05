{ config, pkgs, lib, ... }:

{
  imports = [
    ./screenshot.nix
  ];

  options.modules.scripts.enable = lib.mkEnableOption "*all* scripts";
}
