{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.fonts;
in
{
  options.modules.programs.fonts.enable = lib.mkEnableOption "fonts module";

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages = [
      # https://github.com/NixOS/nixpkgs/blob/nixos-23.11/pkgs/data/fonts/nerdfonts/shas.nix
      (pkgs.nerdfonts.override { fonts = [
        "JetBrainsMono"
        "Mononoki"
        "FiraCode"
        "CascadiaCode"
      ]; })
      pkgs.dejavu_fonts
      pkgs.liberation_ttf
      pkgs.open-sans
      pkgs.ubuntu_font_family
      pkgs.source-sans-pro
      pkgs.charis-sil
      pkgs.fira
      inputs.sf-mono-nerd-font.packages.x86_64-linux.sf-mono # TODO: update this to be generic to different systems
    ];
  };
}
