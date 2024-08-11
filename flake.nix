{
  description = "home manager flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";  # have hm inherit nixpkgs from current flake
      };
    };
    nix-colors = {
      # url = "github:austinliuigi/nix-colors";
      url = "git+file:///home/austin/projects/nix-colors?ref=refs/heads/main&rev=b86e8be53bb6a09a4be3a1ff0d19889495f0dd67";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
    sf-mono-nerd-font = {
      url = "github:austinliuigi/sf-mono-nerd-font-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprland = {
    #   url = "github:hyprwm/Hyprland";
    # };
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
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
