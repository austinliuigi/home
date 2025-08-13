{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.langs.javascript;
in {
  options.modules.langs.javascript = {
    enable = lib.mkEnableOption "javascript module";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      # pkgs.typescript
      pkgs.nodePackages_latest.typescript-language-server
      pkgs.prettierd
    ];
  };
}
