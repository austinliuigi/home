{ config, pkgs, lib, ... }:

{
  home.packages = [
    pkgs.xclip
    pkgs.xdg-utils
    pkgs.deno
    pkgs.pamixer
    pkgs.gimp
    pkgs.inkscape
    pkgs.blender
    pkgs.nodejs
    # pkgs.brave
    pkgs.nyxt
    pkgs.pandoc
    pkgs.signal-desktop
    pkgs.ttyper
    pkgs.vlc

    pkgs.glxinfo
    pkgs.wlr-randr
    pkgs.lshw
    pkgs.dmidecode
    pkgs.gparted
  ];

  modules = {
    programs = {
      c.enable           = true;
      common.enable      = true;
      core.enable        = true;
      direnv.enable      = true;
      dunst.enable       = true;
      fonts.enable       = true;
      fzf.enable         = true;
      gtk.enable         = true;
      ios.enable         = true;
      javascript.enable  = true;
      kdeconnect.enable  = true;
      kitty.enable       = true;
      live-server.enable = true;
      lua.enable         = true;
      mpv.enable         = true;
      neovim.enable      = true;
      nix.enable         = true;
      pcmanfm.enable     = true;
      python.enable      = true;
      sioyek.enable      = true;
      syncthing.enable   = true;
      tex.enable         = true;
      wezterm.enable     = true;
      zoxide.enable      = true;
      zsh.enable         = true;
    };
    txn = {
      shroomish.enable = true;
      cursors.enable = true;
    };
  };
}
