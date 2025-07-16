{
  description = "home manager flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";  # have hm inherit nixpkgs from current flake
    };
    nix-colors = {
      url = "github:austinliuigi/nix-colors";
      # url = "path:/home/austin/projects/nix-colors";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay/098d2af8c606ea8adc1b8b3084f454ca681a7ab3";
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
        txn-desktop = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = baseExtraSpecialArgs;
          modules = [
            ./modules
            ./users/txn/desktop.nix
          ];
        };
        txn-server = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = baseExtraSpecialArgs;
          modules = [
            ./modules
            ./users/txn/server.nix
          ];
        };
      };
    };
}
