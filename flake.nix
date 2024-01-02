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
    nix-colors = {
      url = "github:misterio77/nix-colors";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      utils = (import ./utils.nix) { lib = nixpkgs.lib; };
      baseExtraSpecialArgs = {
        inherit inputs;
        inherit utils;
      };
    in {
      homeConfigurations = {
        bootstrap = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = baseExtraSpecialArgs;
          modules = [
            ./users/bootstrap
          ];
        };
        austin = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = baseExtraSpecialArgs;
          modules = [
            ./modules
            ./users/austin
          ];
        };
        austin-light = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = baseExtraSpecialArgs;
          modules = [
            ./modules
            ./users/austin/light.nix
          ];
        };
      };
    };
}
