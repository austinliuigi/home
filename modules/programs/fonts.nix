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
        "Agave"
      ]; })
      pkgs.dejavu_fonts
    ];
  };
}
