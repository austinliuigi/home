{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programming_languages.javascript;
in
{
  options.modules.programming_languages.javascript = {
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
