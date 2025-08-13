{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.langs.c;
in {
  options.modules.langs.c = {
    enable = lib.mkEnableOption "c module";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.clang-tools_16
      pkgs.gdb
      pkgs.valgrind
    ];
  };
}
