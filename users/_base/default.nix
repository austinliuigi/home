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
}
