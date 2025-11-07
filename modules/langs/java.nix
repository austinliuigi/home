{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.langs.java;
in {
  options.modules.langs.java = {
    enable = lib.mkEnableOption "java module";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.jdk
      pkgs.google-java-format
    ];
  };
}
