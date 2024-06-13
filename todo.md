- import dotfiles dependencies.nix if builtins.pathExists
    - use it to specify configuration specific dependencies, e.g. rofi for hyprland
    - can also migrate the logic of symlinking config files and interpolating config files
        - would make separate user dotfiles more sensible
- cache colorized files
    1. create colorized files in cache if it doesnt already exist
    2. link file to cache file
- refactor wallpaper to be like color.nix
- refactor scripts to use native bash and systemd units
    - need custom way to symlink leaves of directory?
        - use `lndir`
        - see https://github.com/nix-community/home-manager/blob/80546b220e95a575c66c213af1b09fe255299438/modules/files.nix#L64
        - see https://github.com/nix-community/home-manager/blob/80546b220e95a575c66c213af1b09fe255299438/modules/files.nix#L330
- decide on using native systemd units or home-manager service
    - home-manager has the benefit of automatically starting/stopping/restarting
    - home-manager can also easily include absolute paths to programs using string interpolation
- create module for udiskie that runs via a systemd service on startup
    - reference dunst config for systemd service
    - https://www.youtube.com/watch?v=eVZBvRkLqaE
- consider not automatically importing all modules
- consider refactoring users hierarchy
- rename tin to personal
- use pkill instead of pgrep
- unify font and palette into theme?
- separate hypr palette from hyprland config
    - have an individual hypr module
- use writeTextFile derivation instead on substituting
    - allows logic in substitutions, e.g. arithmetic to font size
    - return derivation from file
    - symlink derivation result to .local/share/

# Configuring Programs

## 1. pkg vs. module

*pkgs*:
- changing config doesn't require a rebuild
- native configuration is one less level of abstraction

*modules*:
- access to nix variables
- can integrate more tightly with rest of nix configuration

**consensus**:
- use pkg if module is just a wrapper around config
- use module if it does anything more, e.g. adds systemd units

## 2. configuration files

- use module method if using module and it alters the config file
- use pkg method if using pkgs or module doesn't alter config file

*module method*:

```
if config can include other files
    source native config files in extraConfig option
    symlink sourced config files
    separate color configuration into one file in XDG_DATA_DIR that gets interpolated
else
    interpolate file to the nix store
    add interpolated file contents in extraConfig option  # reloading requires a new gen
```

*pkg method*:

```
if config can include other files
    use symlink to config dir
    separate color configuration into one file in XDG_DATA_DIR that gets interpolated
else
    for each config file
        if no color configuration
            use symlink to config file
        else
            interpolate config file  # reloading requires a new gen
``
