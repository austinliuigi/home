# Development shell for python projects. This is meant to be used alongside a native python package manager.
# Uses nix-ld to make specified dynamic libraries discoverable by the linker (required by some python packages, e.g. numpy)
{
  lib,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    devShells = let
      PYTHON_VERSION = "3.10.1";
      pkgs-python = inputs.nixpkgs-python.packages.${system};
    in {
      default = pkgs.mkShell {
        # general packages to install
        packages = [
          pkgs-python.${PYTHON_VERSION}
          pkgs.uv
          # ... <- add nix packages here
        ];

        # packages with depended-on dynamic libraries
        NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
          pkgs.stdenv.cc.cc
          # ... <- add nix packages with depended-on dynamic libraries here
        ];

        NIX_LD = lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
        shellHook = ''
          # force the use of the ld wrapper provided by nix-ld even for python interpreters patched for nix
          export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
        '';
      };
    };
  };
}
