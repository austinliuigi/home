{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.scripts.notes;
in {
  options.modules.scripts.notes.enable = lib.mkEnableOption "notes script";

  config = lib.mkIf cfg.enable {
    home.file = {
      "scripts/notes".source = config.lib.file.mkOutOfStoreSymlink "${config.scripts.notes}";
      ".local/bin/notes".source = config.lib.file.mkOutOfStoreSymlink "${config.scripts.notes}";
    };
  };
}
