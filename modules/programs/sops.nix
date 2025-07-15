{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.sops;
in
{
  options.modules.programs.sops.enable = lib.mkEnableOption "sops module";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.sops
      pkgs.age
    ];
    home.file = {
      ".sops.yaml".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.sops}/.sops.yaml";
      ".secrets".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.sops}/.secrets";
    };
  };
}
