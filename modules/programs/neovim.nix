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

    home.packages = [ pkgs.neovim-nightly ];

    home.file = {
      ".local/share/nvim/palette.lua".text = config.configuration.interpolateConfigFileWithMsg { file = "${/. + "${config.dotfiles.neovim}/.local/share/nvim/palette.lua"}"; comment_start = "--"; };
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.neovim}/.config/nvim";
    };
  };
}
