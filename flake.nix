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
      # myHomeManagerModules = builtins.attrValues (import ./modules);
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};  # strip out non-packages from nixpkgs (e.g. nixpkgs.lib, etc.)
    in {
      homeConfigurations = {
        austin = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./modules
            ./users/austin.nix
          ];
        };
      };
    };
}
