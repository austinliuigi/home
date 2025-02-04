{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.bash;
in
{
  options.modules.programs.bash.enable = lib.mkEnableOption "bash module";

  config = lib.mkIf cfg.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;

      bashrcExtra = ''
        source ~/.config/bash/config/aliases.sh
      '';

      initExtra = ''
        # source ~/.config/bash/config/aliases.sh
        source ~/.config/bash/config/prompt.sh
        source ~/.config/bash/config/bashrc
      '';
    };

    home.file = {
      ".config/bash/config".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.bash}/.config/bash/config";
    };
  };
}
