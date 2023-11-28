{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.neovim;
in
{
  options.modules.programs.neovim.enable = lib.mkEnableOption "neovim module";

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [
      inputs.neovim-nightly-overlay.overlay
    ];

    home.packages = [
      pkgs.neovim-nightly
    ];

    home.file = {
      ".local/state/nvim/palette.lua" = config.configuration.interpolateConfigFileWithMsg { file = "${/. + "${config.dotfiles.neovim}/.local/state/nvim/palette.lua"}"; comment_start = "--"; };
    };

    # create a symlink of the config to the proper location
    xdg.configFile = {
      nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.neovim}/.config/nvim";
    };
  };
}
