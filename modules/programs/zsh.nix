{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.zsh;
in
{
  options.modules.programs.zsh.enable = lib.mkEnableOption "zsh module";

  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      enableCompletion = true;
      plugins = [
        # {
        #   name = "zsh-autosuggestions";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "zsh-users";
        #     repo = "zsh-autosuggestions";
        #     rev = "v0.7.0";
        #     sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        #   };
        # }
        # {
        #   name = "zsh-syntax-highlighting";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "zsh-users";
        #     repo = "zsh-syntax-highlighting";
        #     rev = "0.7.1";
        #     sha256 = "sha256-gOG0NLlaJfotJfs+SUhGgLTNOnGLjoqnUp54V9aFJg8=";
        #   };
        # }
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
      ];
      history = {
        # Note: these will get overriden by our own zshrc
        size = 999999;
        save = 999999;
        path = "${config.home.homeDirectory}/.local/state/zsh/zsh_history";
        ignoreDups = false;
        ignoreAllDups = false;
        ignoreSpace = false;
        expireDuplicatesFirst = false;
        share = false;
        extended = false;
      };
      autosuggestion.enable = true;
      syntaxHighlighting = {
        enable = true;
      };
      initExtra = ''
        source ~/.config/zsh/config/aliases.zsh
        source ~/.config/zsh/config/keybinds.zsh
        source ~/.config/zsh/config/prompt.zsh
        source ~/.config/zsh/config/zshrc
      '';
    };

    home.file = {
      ".config/zsh/config".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.zsh}/.config/zsh/config";
    };
  };
}
