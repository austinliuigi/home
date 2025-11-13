{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.scripts.todo;
in {
  options.modules.scripts.todo.enable = lib.mkEnableOption "todo script";

  config = lib.mkIf cfg.enable {
    home.file = {
      "scripts/todo".source = config.lib.file.mkOutOfStoreSymlink "${config.scripts.todo}";
      ".local/bin/todo".source = config.lib.file.mkOutOfStoreSymlink "${config.scripts.todo}";
    };
  };
}
