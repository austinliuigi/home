{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  options.font = lib.mkOption {
    type = lib.types.attrs;
    default = {};
  };

  config = {
    fonts.fontconfig.enable = true;

    home.packages = [
      # nerd fonts: https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/data/fonts/nerd-fonts/manifests/fonts.json
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.fira-code
      pkgs.nerd-fonts.meslo-lg
      pkgs.nerd-fonts.symbols-only

      pkgs.roboto-mono
      pkgs.dejavu_fonts
      pkgs.liberation_ttf
      pkgs.open-sans
      pkgs.source-sans-pro
      pkgs.charis-sil
      pkgs.fira
      inputs.sf-mono-nerd-font.packages.x86_64-linux.sf-mono # TODO: update this to be generic to different systems
    ];

    font = {
      mono = "SFMono Nerd Font";
      sans = "Ubuntu";
      serif = "Liberation Serif";
    };

    home.file = {
      ".cache/font.dummy".text = ''
        # this is a dummy file used to detect a font change in nix
        ${config.font.mono}
        ${config.font.sans}
        ${config.font.serif}
      '';
    };

    configuration.substitutions = {
      font_mono = "${config.font.mono}";
      font_sans = "${config.font.sans}";
      font_serif = "${config.font.serif}";
    };
  };
}
