{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.fonts;
in
{
  options.modules.programs.fonts.enable = lib.mkEnableOption "fonts module";

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;

    home.packages = [
      # nerd fonts: https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/data/fonts/nerd-fonts/manifests/fonts.json
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.mononoki
      pkgs.nerd-fonts.fira-code
      pkgs.nerd-fonts.symbols-only

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
