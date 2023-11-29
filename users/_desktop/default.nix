{ config, pkgs, lib, ... }:

{
  home.packages = [
    pkgs.xclip
    pkgs.deno
    pkgs.gimp
    pkgs.inkscape
    pkgs.nodejs
    pkgs.nyxt
    pkgs.pandoc
    pkgs.ttyper
    pkgs.vlc
  ];

  modules = {
    scripts.enable = true;
    programs = {
      c.enable            = true;
      common.enable       = true;
      core.enable         = true;
      fzf.enable          = true;
      ios.enable          = true;
      kdeconnect.enable   = true;
      kitty.enable        = true;
      lua.enable          = true;
      neovim.enable       = true;
      nix.enable          = true;
      python.enable       = true;
      sioyek.enable       = true;
      syncthing.enable    = true;
      texlive.enable      = true;
      zoxide.enable       = true;
      zsh.enable          = true;
    };
  };
}
