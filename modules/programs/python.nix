{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.python;
in
{
  options.modules.programs.python = {
    enable = lib.mkEnableOption "python module";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.poetry
      (pkgs.python311.withPackages (ps: with ps; [
        pynvim
        virtualenv
        debugpy
        pylint
      ]))
      pkgs.pyright
      pkgs.manim
    ];
  };
}
