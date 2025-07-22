{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.fzf;

  # wrap fzf to use palette
  #   - better than an alias or function because they work in non-interactive shells
  #     - bash allows exporting functions but zsh doesn't
  #   - better than a signal handler that refreshes FZF_DEFAULT_OPTS because there's
  #     a lot of edge cases to consider when finding all the shells to send a signal to
  fzf_wrapper = pkgs.writeShellScriptBin "fzf" ''
    source ~/.local/share/fzf/palette.sh

    # export FZF_DEFAULT_OPTS=\
    # " --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D"\
    # " --color=fg:$color03,header:$color0D,info:$color0A,pointer:$color0C"\
    # " --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"

    WRAPPER_OPTS="$(echo \
    " --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D"\
    " --color=fg:$color03,header:$color0D,info:$color0A,pointer:$color0C"\
    " --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"
    )"

    ${pkgs.fzf}/bin/fzf "$@" $WRAPPER_OPTS </proc/$$/fd/0 >/proc/$$/fd/1 2>/proc/$$/fd/2
  '';
in
{
  options.modules.programs.fzf.enable = lib.mkEnableOption "fzf module";

  config = lib.mkIf cfg.enable {
    home.packages = [ fzf_wrapper ];

    home.file = {
      ".local/share/fzf/palette.sh" = {
        text = config.configuration.interpolateConfigFileWithMsg { file = "${config.dotfiles.fzf}/.local/share/fzf/palette.sh"; comment_start = "#"; };
      };
      ".config/fzf".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.fzf}/.config/fzf";
    };

    programs.bash.initExtra = ''
      source ${pkgs.fzf}/share/fzf/completion.bash
      source ${pkgs.fzf}/share/fzf/key-bindings.bash
      source ~/.config/fzf/fzfrc
    '';

    programs.zsh.initContent = ''
      source ${pkgs.fzf}/share/fzf/completion.zsh
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ~/.config/fzf/fzfrc
    '';
  };
}
