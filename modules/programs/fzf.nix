{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.fzf;
in
{
  options.modules.programs.fzf.enable = lib.mkEnableOption "fzf module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.fzf ];

    home.file = {
      ".local/share/fzf/palette.sh" = {
        text = config.configuration.interpolateConfigFileWithMsg { file = "${config.dotfiles.fzf}/.local/share/fzf/palette.sh"; comment_start = "#"; };
        # Source palette.sh on colorscheme change
        #   Option 1: make script that uses bash trap builtin to handle SIGUSR1 signal
        #     - run script in background in bashrc
        #     - kill -SIGUSR1 the script onChange
        #     - won't dynamically change running fzf processes
        #   Option 2: make wrapper script around fzf that uses bash trap builtin to handle SIGUSR1 signal
        #     - run fzf with --print-query by default
        #     - in trap function, update FZF_DEFAULT_OPTS and run fzf with --print-query to allow
        #        multiple calls and --query option to restore state of previous fzf
        #     - script should forward the output of fzf with the printed query stripped away

        onChange = ''
          # note: busybox's pgrep implementation doesn't include the --full flag, but does include the synonomous -f flag
          # bash_procs=$(${pkgs.busybox}/bin/pgrep -f bash || true)
          # if [ -n "$bash_procs" ]; then
          #   echo "fzf: reloading config"
          #   # this may also catch the sub-shell that is used to invoke the kill command, so we need to ignore the error
          #   kill -SIGUSR1 $bash_procs 2>/dev/null || true
          # fi

          # note: busybox's pgrep implementation doesn't include the --full flag, but does include the synonomous -f flag
          zsh_procs=$(${pkgs.busybox}/bin/pgrep -f zsh || true)
          for proc in $zsh_procs; do
            echo $proc
            # echo "$(${pkgs.ps}/bin/ps aux | grep $proc)"
            kill -SIGUSR1 $zsh_procs 2>/dev/null
          done
          # if [ -n "$zsh_procs" ]; then
          #   echo "fzf: reloading config"
          #   # this may also catch the sub-shell that is used to invoke the kill command, so we need to ignore the error
          #   kill -SIGUSR1 $zsh_procs 2>/dev/null || true
          # fi
        '';
      };
      ".config/fzf".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.fzf}/.config/fzf";
    };

    programs.bash.initExtra = ''
      source ${pkgs.fzf}/share/fzf/completion.bash
      source ${pkgs.fzf}/share/fzf/key-bindings.bash
      source ~/.config/fzf/fzfrc
      source ~/.local/share/fzf/palette.sh
    '';

    programs.zsh.initExtra = ''
      source ${pkgs.fzf}/share/fzf/completion.zsh
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ~/.config/fzf/fzfrc
      source ~/.local/share/fzf/palette.sh
    '';
  };
}
