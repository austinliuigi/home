{ pkgs, lib, config, inputs, ... }:

{
  options.font = lib.mkOption {
    type = lib.types.str;
    default = "Monospace";
  };

  config = rec {
    font = "Mononoki Nerd Font";

    home.file = {
      ".cache/font.dummy".text = ''
        # this is a dummy file used to detect a font change in nix
        ${config.font}
      '';
    };

    # home.file = {
    #   ".cache/palette.dummy".text = lib.mkAfter ''
    #     ${config.font}
    #   '';
    # };

    configuration.substitutions = {
      font = "${config.font}";
    };
  };
}
