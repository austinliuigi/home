{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programming_languages.c;
in
{
  options.modules.programming_languages.c = {
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
