{
  config,
  pkgs,
  lib,
  ...
}: {
  home.sessionPath = ["$HOME/.local/bin"];

  services.ssh-agent.enable = true;

  home.packages = [
    pkgs.lshw
    pkgs.dmidecode
  ];

  modules = {
    programs = {
      bash.enable = true;
      btop.enable = true;
      common.enable = true;
      core.enable = true;
      direnv.enable = true;
      fzf.enable = true;
      gdu.enable = true;
      git.enable = true;
      neovim.enable = true;
      pet.enable = true;
      syncthing.enable = true;
      zoxide.enable = true;
      zsh.enable = true;
    };
    langs = {
      c.enable = false;
      java.enable = false;
      javascript.enable = false;
      lua.enable = false;
      typst.enable = false;
      nix.enable = false;
      python.enable = false;
    };
    scripts = {
      todo.enable = true;
      notes.enable = true;
    };
  };
}
