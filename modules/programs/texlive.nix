{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.texlive;
in
{
  options.modules.programs.texlive.enable = lib.mkEnableOption "texlive module";

  config = lib.mkIf cfg.enable {
    programs.texlive = {
      enable = true;
      extraPackages = tpkgs: {
        inherit (tpkgs) scheme-full standalone;
      };
    };
  };
}
