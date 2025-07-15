{ pkgs, lib, config, inputs, utils, ... }:

let
  cfg = config.modules.programs.git;
in
{
  options.modules.programs.git.enable = lib.mkEnableOption "git module";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.git
      pkgs.gh
    ];

    home.file = {
      ".config/git".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.git}/.config/git";
    };
  };
}
