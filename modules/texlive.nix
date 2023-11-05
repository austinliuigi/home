{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.texlive;
in
{
  options = {
    modules.texlive = {
      enable = lib.mkEnableOption "Texlive module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.texlive = {
      enable = true;
      extraPackages = tpkgs: {
        inherit (tpkgs) scheme-medium standalone;
      };
    };
  };
}
