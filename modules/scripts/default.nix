{ config, pkgs, lib, ... }:

{
  options.modules.scripts.enable = lib.mkEnableOption "*all* scripts";
}
