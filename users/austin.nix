{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "austin";
  home.homeDirectory = "/home/austin";

  # The home.packages nix modules option allows you to install Nix packages into your environment
  home.packages = [
    pkgs.neovim
    pkgs.lsd
    pkgs.clang-tools
    pkgs.stylua
    pkgs.lua-language-server
    pkgs.zsh
    pkgs.fzf
    pkgs.nyxt
    pkgs.gimp
    pkgs.inkscape
    pkgs.nodejs
    pkgs.deno
    pkgs.pandoc
    pkgs.python311Packages.weasyprint
    pkgs.zathura
    pkgs.ttyper
    pkgs.vlc
  ];

  modules.scripts.enable = true;

  programs.texlive = {
    enable = true;
    extraPackages = tpkgs: {
      inherit (tpkgs) scheme-medium standalone;
    };
  };

  services.syncthing = {
    enable = true;
  };

  # Manage configuration for hyprland
  # - this adds systemd support -> graphical-session.target gets run
  #     - this is needed for systemd reliant programs, e.g. kdeconnect
  wayland.windowManager.hyprland = {
    enable = true;
    # systemd.enable = true;
    extraConfig = ''
    source = ~/.config/home-manager/configs/hyprland/settings.conf
    source = ~/.config/home-manager/configs/hyprland/keybinds.conf
    source = ~/.config/home-manager/configs/hyprland/rules.conf
    exec-once = waybar & hyprpaper &
    '';
  };

  services.swayidle =
    let 
      lock_cmd = "${pkgs.swaylock}/bin/swaylock -fF --color 0000ff --ring-color aaaaaa --key-hl-color dddddd -l";
      dpms_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms";
    in {
      enable = true;
      systemdTarget = "hyprland-session.target";
      timeouts = [
        { timeout = 300; command = lock_cmd; }
        { timeout = 600; command = "${dpms_cmd} off"; resumeCommand = "${dpms_cmd} on"; }
      ];
      events = [
        { event = "before-sleep"; command = lock_cmd; }
        { event = "lock"; command = lock_cmd; }
      ];
    };

  services.kdeconnect = {
    enable = true;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
  };

  xdg.configFile = {
    nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/configs/nvim";
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.home-manager.enable = true;  # install and manage home-manager

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.
}
