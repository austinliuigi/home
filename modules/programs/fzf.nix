{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.fzf;
in
{
  options.modules.programs.fzf.enable = lib.mkEnableOption "fzf module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.fzf ];

    home.file = {
      ".local/share/fzf/palette.sh".text = config.configuration.interpolateConfigFileWithMsg { file = "${/. + "${config.dotfiles.fzf}/.local/share/fzf/palette.sh"}"; comment_start = "#"; };
      ".config/fzf".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.fzf}/.config/fzf";
    };

    programs.bash.initExtra = ''
      source ${pkgs.fzf}/share/fzf/completion.bash
      source ${pkgs.fzf}/share/fzf/key-bindings.bash
      source ~/.config/fzf/default.sh
      source ~/.local/share/fzf/palette.sh
    '';

    programs.zsh.initExtra = ''
      source ${pkgs.fzf}/share/fzf/completion.zsh
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ~/.config/fzf/default.sh
      source ~/.local/share/fzf/palette.sh
    '';
  };
}
