{
  description = "home manager flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";  # have hm inherit nixpkgs from current flake
      };
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      # takes a func and generates an attr where key = <elem> and val = func called with <elem>
      forEachSystem = nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ];

      utils = forEachSystem (system: (import ./utils.nix) {
        pkgs = nixpkgs.legacyPackages.${system};
        lib = nixpkgs.lib;
      });
    in {
      homeConfigurations = {
        austin = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs;
            utils = utils.x86_64-linux;
          };
          modules = [
            ./modules
            ./users/austin
          ];
        };
        austin-light = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            inherit inputs;
            utils = utils.x86_64-linux;
          };
          modules = [
            ./modules
            ./users/austin-light
          ];
        };
      };
    };
}
