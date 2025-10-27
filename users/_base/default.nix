{
  config,
  pkgs,
  lib,
  ...
}: {
  options.dotfiles = lib.pipe (builtins.attrNames (builtins.readDir ./dotfiles)) [
    (builtins.map (program: {
      name = program;
      value = lib.mkOption {
        type = lib.types.str;
        readOnly = false; # other users can override specific program dotfiles
        default = "${config.home.homeDirectory}/.config/home-manager/users/_base/dotfiles/${program}";
        # _default = {
        #   impure_path = "${config.home.homeDirectory}/.config/home-manager/users/_base/dotfiles/${program}"; # use this for symlinks
        #   pure_path = "./dotfiles/${program}"; # use this for subsituting files
        # };
        description = ''
          Path to dotfiles directory for ${program}
        '';
      };
    }))
    builtins.listToAttrs
  ];
  options.scripts = lib.pipe (builtins.attrNames (builtins.readDir ./scripts)) [
    (builtins.map (script: {
      name = script;
      value = lib.mkOption {
        type = lib.types.str;
        readOnly = false;
        default = "${config.home.homeDirectory}/.config/home-manager/users/_base/scripts/${script}";
        description = ''
          Path to script for ${script}
        '';
      };
    }))
    builtins.listToAttrs
  ];
  # options.dotfiles =
  #   (builtins.listToAttrs
  #     (builtins.map
  #       (program:
  #         {
  #           name = program;
  #           value = lib.mkOption {
  #             type = lib.types.str;
  #             readOnly = false;  # other users can override specific program dotfiles
  #             default = "${config.home.homeDirectory}/.config/home-manager/users/_base/dotfiles/${program}";
  #             # _default = {
  #             #   impure_path = "${config.home.homeDirectory}/.config/home-manager/users/_base/dotfiles/${program}"; # use this symlinks
  #             #   pure_path = "./dotfiles/${program}"; # use this for building files
  #             # };
  #             description = ''
  #               Path to dotfiles directory for ${program}
  #             '';
  #           };
  #         }
  #       )
  #       (builtins.attrNames (builtins.readDir ./dotfiles))
  #     )
  #   );
  # options.scripts =
  #   (builtins.listToAttrs
  #     (builtins.map
  #       (script:
  #         {
  #           name = script;
  #           value = lib.mkOption {
  #             type = lib.types.str;
  #             readOnly = false;
  #             default = "${config.home.homeDirectory}/.config/home-manager/users/_base/scripts/${script}";
  #             description = ''
  #               Path to script for ${script}
  #             '';
  #           };
  #         }
  #       )
  #       (builtins.attrNames (builtins.readDir ./scripts))
  #     )
  #   );
}
