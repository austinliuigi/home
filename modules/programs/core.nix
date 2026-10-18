{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.programs.core;
in {
  options.modules.programs.core.enable = lib.mkEnableOption "core utilities module";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.acpi
      pkgs.file
      pkgs.ltrace
      pkgs.pstree
      pkgs.stow
      pkgs.tree
      pkgs.unzip
      pkgs.wev
      pkgs.zip
      pkgs.iw
      pkgs.iperf3
      pkgs.ethtool
    ];
  };
}
