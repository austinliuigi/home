{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.programs.zsh;
in {
  options.modules.programs.zsh.enable = lib.mkEnableOption "zsh module";

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      dotDir = config.home.homeDirectory + "/.config/zsh";
      plugins = [
        {
          name = "gitstatus";
          src = pkgs.fetchFromGitHub {
            owner = "romkatv";
            repo = "gitstatus";
            rev = "v1.5.4";
            sha256 = "sha256-mVfB3HWjvk4X8bmLEC/U8SKBRytTh/gjjuReqzN5qTk=";
          };
        }
        {
          name = "fzf-tab";
          src = pkgs.fetchFromGitHub {
            owner = "Aloxaf";
            repo = "fzf-tab";
            rev = "c2b4aa5ad2532cca91f23908ac7f00efb7ff09c9";
            sha256 = "sha256-gvZp8P3quOtcy1Xtt1LAW1cfZ/zCtnAmnWqcwrKel6w=";
          };
        }
        # {
        #   name = "fast-syntax-highlighting";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "zdharma-continuum";
        #     repo = "fast-syntax-highlighting";
        #     rev = "v1.55";
        #     sha256 = "sha256-DWVFBoICroKaKgByLmDEo4O+xo6eA8YO792g8t8R7kA=";
        #   };
        # }
      ];
      # history = {
      #   # Note: these will get overriden by our own zshrc
      #   size = 999999;
      #   save = 999999;
      #   path = "${config.home.homeDirectory}/.local/state/zsh/zsh_history";
      #   ignoreDups = false;
      #   ignoreAllDups = false;
      #   ignoreSpace = false;
      #   expireDuplicatesFirst = false;
      #   share = false;
      #   extended = false;
      # };
      autosuggestion.enable = true;
      syntaxHighlighting = {
        enable = true;
        styles.comment = "fg=#${config.colorscheme.palette.base03}"; # https://github.com/nix-community/home-manager/pull/4122
      };
      zprof.enable = false;
      enableCompletion = true;
      completionInit = ''
        autoload -Uz compinit

        # Only check once a day to see if zcompdump needs a rebuild
        #   - https://gist.github.com/ctechols/ca1035271ad134841284
        #   - https://htr3n.github.io/2018/07/faster-zsh/#optimising-completion-system
        if [ $(date +"%j") != $(date --date="$(stat --printf=%x "''${ZDOTDIR:-$HOME}/.zcompdump")" +"%j") ]; then
                echo checking zcompdump
                compinit;
                touch "''${ZDOTDIR:-$HOME}/.zcompdump" # update access time manually in case no rebulid was necessary
        else
                compinit -C;
        fi;

        # Compile the completion dump to increase startup speed. Run in background.
        #   - https://news.ycombinator.com/item?id=40128826
        #   - https://zsh.sourceforge.io/Doc/Release/Completion-System.html
        {
          zcompdump="''${ZDOTDIR:-$HOME}/.zcompdump"

          # if zcompdump file exists, and we don't have a compiled version or the dump file is newer than the compiled file
          if [[ -s "$zcompdump" && (! -s "''${zcompdump}.zwc" || "$zcompdump" -nt "''${zcompdump}.zwc") ]]; then
            zcompile "$zcompdump"
          fi
        } &!
      '';
      initContent = let
        contentTop = lib.mkBefore ''
          # Compile if the .zwc file does not exist, or the base file is newer.
          # These jobs are asynchronous, and will not impact the interactive shell
          #   - https://medium.com/@voyeg3r/holy-grail-of-zsh-performance-a56b3d72265d
          zcompile_if_needed() {
            if [[ -s ''${1} && ( ! -s ''${1}.zwc || ''${1} -nt ''${1}.zwc) ]]; then
              zcompile ''${1}
            fi
          }
        '';
        content = ''
          source ~/.config/zsh/config/aliases.sh
          source ~/.config/zsh/config/keybinds.zsh
          source ~/.config/zsh/config/prompt.zsh
          source ~/.config/zsh/config/hooks.zsh
          source ~/.config/zsh/config/zshrc
        '';
      in
        lib.mkMerge [contentTop content];
    };

    home.file = {
      ".config/zsh/config".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.zsh}/.config/zsh/config";
    };
  };
}
