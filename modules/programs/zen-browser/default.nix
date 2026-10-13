{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.programs.zen-browser;
in {
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  options.modules.programs.zen-browser.enable = lib.mkEnableOption "zen-browser module";

  config = lib.mkIf cfg.enable {
    programs.zen-browser.enable = true;

    programs.zen-browser.profiles.default = {
      isDefault = true;
    };
    # home.file = {
    #   ".local/share/nvim/palette.lua" = {
    #     text = config.configuration.interpolateConfigFileWithMsg {
    #       file = "${config.dotfiles.zen-browser}/.local/share/nvim/palette.lua";
    #       comment_start = "--";
    #     };
    #     onChange = ''
    #       procs=$(${pkgs.busybox}/bin/pgrep nvim || true)
    #       if [ -n "$procs" ]; then
    #         echo "nvim: sending SIGUSR1"
    #         kill -SIGUSR1 $procs
    #       fi
    #     '';
    #   };
    #   ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.zen-browser}/.config/nvim";
    # };
  };
}
