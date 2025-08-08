{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.programs.pet;
in {
  options.modules.programs.pet.enable = lib.mkEnableOption "pet module";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.pet];

    home.file = {
      ".config/pet".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.pet}/.config/pet";
    };
  };
}
