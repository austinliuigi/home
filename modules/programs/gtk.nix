{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.gtk;
in
{
  options.modules.programs.gtk.enable = lib.mkEnableOption "gtk module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.glib ];

    home.file = {
      # ".config/gtk-4.0/gtk.css" = {
      #   text = config.configuration.interpolateConfigFileWithMsg { file = "${config.dotfiles.gtk}/.config/gtk-4.0/gtk.css"; comment_start = "/*"; comment_end = "*/"; };
      # };
      #
      # ".config/gtk-3.0/gtk.css".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/gtk-4.0/gtk.css";

      ".cache/font.dummy".onChange = ''
        echo "gtk: updating font"

        ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface font-name '${config.font} 12'
      '';

      ".local/share/gtk/palette/gtk3.css" = {
        text = config.configuration.interpolateConfigFileWithMsg { file = "${config.dotfiles.gtk}/.local/share/gtk/palette/gtk3.css"; comment_start = "/*"; comment_end = "*/"; };
        onChange =
          let
            gsettings = "${pkgs.glib}/bin/gsettings";
            schemas = pkgs.gsettings-desktop-schemas;
          in
            ''
              echo "gtk: updating theme"
              export XDG_DATA_DIRS="${schemas}/share/gsettings-schemas/${schemas.name}:$XDG_DATA_DIRS"
              ${gsettings} set org.gnome.desktop.interface gtk-theme 'Adwaita' && ${gsettings} set org.gnome.desktop.interface gtk-theme 'palette'
            '';
      };

      ".local/share/gtk/palette/gtk2.css" = {
        text = config.configuration.interpolateConfigFileWithMsg { file = "${config.dotfiles.gtk}/.local/share/gtk/palette/gtk2.css"; comment_start = "/*"; comment_end = "*/"; };
      };

      ".themes".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.gtk}/.themes";
    };

    programs.zsh.initExtra = 
      let
        schemas = pkgs.gsettings-desktop-schemas;
      in
      ''
        export XDG_DATA_DIRS="${schemas}/share/gsettings-schemas/${schemas.name}:$XDG_DATA_DIRS"
      '';
  };
}
