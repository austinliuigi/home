{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.modules.programs.tldraw-offline;
in {
  options.modules.programs.tldraw-offline.enable = lib.mkEnableOption "tldraw-offline module";

  config = lib.mkIf cfg.enable {
    home.packages = [inputs.tldraw-offline.packages.${pkgs.stdenv.hostPlatform.system}.tldraw-offline];
  };
}
