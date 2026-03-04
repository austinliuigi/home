{
  description = "Flake for a Python project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-python.url = "github:cachix/nixpkgs-python";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      # global (system independent) flake attributes, treated as if it was in a vanilla flake's output
      flake = {
      };

      # systems for which you want to build each `perSystem` attribute for
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        # "aarch64-darwin"
      ];

      # flake attributes for specified systems, e.g. (perSystem <arg>).packages.default -> packages.<system>.default
      perSystem = {config, ...}: {
      };

      imports = [
        ./flake
      ];
    };
}
