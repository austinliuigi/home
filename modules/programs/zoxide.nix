{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.zoxide;
in
{
  options.modules.programs.zoxide.enable = lib.mkEnableOption "zoxide module";

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.zoxide ];

    programs.bash.initExtra = ''
      eval "$(zoxide init bash)"
    '';

    programs.zsh.initExtra = ''
      eval "$(zoxide init zsh)"
    '';
  };
}
