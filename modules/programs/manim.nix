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
    modules.langs.python.enable = true;

    # TODO: re-enable when fixed in nixpkgs
    # pythonLibraries = [
    #   "manim"
    # ];

    home.file = {
      ".config/manim".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.manim}/.config/manim";
      ".local/share/manim/packages/notes".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.manim}/.local/share/manim/packages/notes";
    };

    pythonPaletteLinks = [
      "~/.local/share/manim/packages/notes/src/notes_manim/palette.py"
    ];
  };
}
