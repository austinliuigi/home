{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.langs.typst;
in {
  options.modules.langs.typst = {
    enable = lib.mkEnableOption "typst module";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.typst
      pkgs.typstyle
      pkgs.tinymist
    ];

    home.file = {
      ".local/share/typst/packages/local/notes".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.typst}/.local/share/typst/packages/local/notes";

      ".local/share/typst/palette.typ" = {
        text = config.configuration.interpolateConfigFileWithMsg {
          file = "${config.dotfiles.typst}/.local/share/typst/palette.typ";
          comment_start = "//";
        };
        # HACK: symlink palette to local packages that need it because only files in a project root can be imported
        # TODO: don't hardcode version numbers
        onChange = ''
          ln -s ~/.local/share/typst/palette.typ ~/.local/share/typst/packages/local/notes/1.0.0/palette.typ || true
        '';
      };
    };
  };
}
