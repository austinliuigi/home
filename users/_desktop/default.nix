{ config, pkgs, lib, ... }:

{
  home.sessionPath = [ "$HOME/.local/bin" ];

  services.ssh-agent.enable = true;

  home.packages = [
    pkgs.xclip
    # pkgs.deno
    pkgs.pamixer
    pkgs.gimp
    pkgs.inkscape
    pkgs.blender
    pkgs.obs-studio
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
    pkgs.udiskie

    pkgs.gthumb
    pkgs.exiftool

    pkgs.manim
  ];

  modules = {
    programs = {
      bash.enable        = true;
      btop.enable        = true;
      common.enable      = true;
      core.enable        = true;
      direnv.enable      = true;
      dunst.enable       = true;
      foot.enable        = true;
      fzf.enable         = true;
      gdu.enable         = true;
      ghostty.enable     = true;
      git.enable         = true;
      gtk.enable         = true;
      ios.enable         = true;
      kdeconnect.enable  = true;
      kitty.enable       = true;
      live-server.enable = true;
      localsend.enable   = true;
      mpv.enable         = true;
      neovim.enable      = true;
      pcmanfm.enable     = true;
      sioyek.enable      = true;
      sops.enable        = true;
      syncthing.enable   = true;
      tex.enable         = true;
      wezterm.enable     = true;
      xdg.enable         = true;
      zoxide.enable      = true;
      zsh.enable         = true;
    };
    programming_languages = {
      c.enable           = true;
      javascript.enable  = true;
      lua.enable         = true;
      nix.enable         = true;
      python.enable      = true;
    };
    scripts = {
      todo.enable        = true;
      menu.enable        = true;
      fzmenu.enable      = true; 
    };
    txn = {
      shroomish.enable = true;
      cursors.enable = true;
    };
  };
}
