{ pkgs, lib, config, inputs, ... }:

let
  cfg = config.modules.programs.tex;
in
{
  options.modules.programs.tex = {
    enable = lib.mkEnableOption "tex module";
  };

  config = lib.mkIf cfg.enable {
    programs.texlive = {
      enable = true;
      extraPackages = tpkgs: {
        inherit (tpkgs) scheme-full standalone;
      };
    };
    home.packages = [
      pkgs.texlab
    ];
  };
}
