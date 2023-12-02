{ config, pkgs, lib, ... }:

{
  home.packages = [
    pkgs.xclip
    pkgs.deno
    pkgs.gimp
    pkgs.inkscape
    pkgs.gnome.adwaita-icon-theme
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
      dunst.enable        = true;
      fzf.enable          = true;
      ios.enable          = true;
      kdeconnect.enable   = true;
      kitty.enable        = true;
      lua.enable          = true;
      neovim.enable       = true;
      nix.enable          = true;
      pcmanfm.enable      = true;
      python.enable       = true;
      sioyek.enable       = true;
      syncthing.enable    = true;
      texlive.enable      = true;
      zoxide.enable       = true;
      zsh.enable          = true;
    };
  };
}
