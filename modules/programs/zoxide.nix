{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.programs.zoxide;
in {
  options.modules.programs.zoxide.enable = lib.mkEnableOption "zoxide module";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.zoxide];

    programs.bash.initExtra = lib.mkAfter ''
      eval "$(zoxide init bash)"
    '';

    programs.zsh.initContent = lib.mkAfter ''
      eval "$(zoxide init zsh)"
    '';
  };
}
