{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.mpv;
in
{
  options.modules.programs.mpv.enable = lib.mkEnableOption "mpv module";

  config = lib.mkIf cfg.enable {
    # nixpkgs.overlays = [
    #   (final: prev: {
    #     mpv = prev.mpv.override {
    #       scripts = [ final.mpvScripts.uosc final.mpvScripts.thumbfast ];
    #     };
    #   })
    # ];

    home.packages = [ pkgs.mpv ];

    home.file = {
      ".config/mpv".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.mpv}/.config/mpv";
    };
  };
}
