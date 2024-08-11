{ pkgs, lib, config, inputs, ... }:

{
  options.font = lib.mkOption {
    type = lib.types.attrs;
    default = "Monospace";
  };

  config = rec {
    # font = "Mononoki Nerd Font";

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

    # home.file = {
    #   ".cache/palette.dummy".text = lib.mkAfter ''
    #     ${config.font}
    #   '';
    # };

    configuration.substitutions = {
      font_mono = "${config.font.mono}";
      font_sans = "${config.font.sans}";
      font_serif = "${config.font.serif}";
    };
  };
}
