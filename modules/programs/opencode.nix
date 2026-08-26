{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.programs.opencode;
in {
  options.modules.programs.opencode.enable = lib.mkEnableOption "opencode module";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.opencode
      inputs.serena.packages.${pkgs.system}.serena
    ];

    home.file = {
      ".local/share/opencode/themes/palette.json" = {
        text =
          config.configuration.interpolateConfigFile
          "${config.dotfiles.opencode}/.local/share/opencode/themes/palette.json";
      };
      ".config/opencode".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.opencode}/.config/opencode";
    };

    home.activation = {
      moveOpencodeThemes = lib.hm.dag.entryAfter ["writeBoundary"] ''
        echo "Moving interpolated opencode palette theme to .config"
        $DRY_RUN_CMD cp -a ~/.local/share/opencode/themes ~/.config/opencode/
      '';
    };
  };
}
