{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.programs.manim;
in {
  options.modules.programs.manim.enable = lib.mkEnableOption "manim module";

  config = lib.mkIf cfg.enable {
    pythonLibraries = [
      "manim"
    ];
  };
}
