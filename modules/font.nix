{ pkgs, lib, config, inputs, ... }:

{
  options.font = lib.mkOption {
    type = lib.types.str;
    default = "Monospace";
  };

  config = rec {
    font = "Mononoki Nerd Font";
    # font = "JetBrainsMono Nerd Font";

    # experimental
    #   - need to figure out a concrete way to decide when each should be used
    # font_primary = "Mononoki Nerd Font";
    # font_secondary = "Jetbrains Mono Nerd Font";

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
      # font_primary = "${config.font_primary}";
      # font_secondary = "${config.font_secondary}";
    };
  };
}
