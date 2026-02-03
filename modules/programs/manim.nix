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
    # TODO: re-enable when fixed in nixpkgs
    # pythonLibraries = [
    #   "manim"
    # ];

    home.file = {
      ".config/manim".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.manim}/.config/manim";
    };
  };
}
