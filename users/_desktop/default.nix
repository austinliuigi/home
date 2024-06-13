{ config, pkgs, lib, ... }:

{
  home.packages = [
    pkgs.xclip
    pkgs.xdg-utils
    pkgs.deno
    pkgs.pamixer
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
    programs = {
      c.enable            = true;
      common.enable       = true;
      core.enable         = true;
      dunst.enable        = true;
      fonts.enable        = true;
      fzf.enable          = true;
      gtk.enable          = true;
      ios.enable          = true;
      kdeconnect.enable   = true;
      kitty.enable        = true;
      live-server.enable  = true;
      lua.enable          = true;
      mpv.enable          = true;
      neovim.enable       = true;
      nix.enable          = true;
      pcmanfm.enable      = true;
      python.enable       = true;
      sioyek.enable       = true;
      syncthing.enable    = true;
      texlive.enable      = true;
      wezterm.enable      = true;
      zoxide.enable       = true;
      zsh.enable          = true;
    };
    tin = {
      shroomish.enable = true;
    };
  };
}
