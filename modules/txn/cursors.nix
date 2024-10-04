{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.txn.cursors;
in
{
  options.modules.txn.cursors.enable = lib.mkEnableOption "txn's cursors module";

  config = lib.mkIf cfg.enable {
    home.file = {
      ".icons".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.txn}/.icons";
    };
  };
}
