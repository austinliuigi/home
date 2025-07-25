{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.gdu;

  gdu_wrapper = pkgs.writeShellScriptBin "gdu" ''
    TMP_CONFIG="$(mktemp -t XXXXXX.yaml)"
    cat ~/.config/gdu/gdu.yaml ~/.local/share/gdu/palette.yaml > "$TMP_CONFIG"

    ${pkgs.gdu}/bin/gdu "$@" --config-file="$TMP_CONFIG" </proc/$$/fd/0 >/proc/$$/fd/1 2>/proc/$$/fd/2
  '';
in
{
  options.modules.programs.gdu.enable = lib.mkEnableOption "gdu module";

  config = lib.mkIf cfg.enable {
    home.packages = [ gdu_wrapper ];

    home.file = {
      ".local/share/gdu/palette.yaml" = {
        text = config.configuration.interpolateConfigFileWithMsg { file = "${config.dotfiles.gdu}/.local/share/gdu/palette.yaml"; comment_start = "#"; };
      };
      ".config/gdu".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.gdu}/.config/gdu";
    };
  };
}
