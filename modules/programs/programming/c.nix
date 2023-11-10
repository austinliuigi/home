{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.c;
in
{
  options.modules.programs.c = {
    enable = lib.mkEnableOption "c module";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.clang-tools
      pkgs.gdb
      pkgs.valgrind
    ];
  };
}
