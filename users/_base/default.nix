{ config, pkgs, lib, ... }:

{
  options.dotfiles = 
    (builtins.listToAttrs
      (builtins.map
        (program:
          {
            name = program;
            value = lib.mkOption {
              type = lib.types.str;
              readOnly = false;  # other users can override specific program dotfiles
              default = "${config.home.homeDirectory}/.config/home-manager/users/_base/dotfiles/${program}";
              description = ''
                Path to dotfiles directory for ${program}
              '';
            };
          }
        )
        (builtins.attrNames (builtins.readDir ./dotfiles))
      )
    );
  options.scripts = 
    (builtins.listToAttrs
      (builtins.map
        (script:
          {
            name = script;
            value = lib.mkOption {
              type = lib.types.str;
              readOnly = false;
              default = "${config.home.homeDirectory}/.config/home-manager/users/_base/scripts/${script}";
              description = ''
                Path to script for ${script}
              '';
            };
          }
        )
        (builtins.attrNames (builtins.readDir ./scripts))
      )
    );
}
