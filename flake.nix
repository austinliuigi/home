{
  description = "home manager flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # have hm inherit nixpkgs from current flake
    };
    nix-colors = {
      url = "github:austinliuigi/nix-colors";
      # url = "path:/home/austin/projects/nix-colors";
    };
    neovim-nightly-overlay = {
      # url = "github:nix-community/neovim-nightly-overlay/098d2af8c606ea8adc1b8b3084f454ca681a7ab3";
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

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    utils = (import ./utils.nix) {lib = nixpkgs.lib;};
    baseExtraSpecialArgs = {
      inherit inputs;
      inherit utils;
    };
    servers = ["cloudlab"];
    desktops = ["x1-carbon" "ghost-s1"];
    trace = false;
  in
    (expr:
      if trace
      then nixpkgs.lib.debug.traceValSeqN 2 expr
      else expr) {
      homeConfigurations =
        {
          bootstrap = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;
            extraSpecialArgs = baseExtraSpecialArgs;
            modules = [
              ./users/bootstrap
            ];
          };
        }
        // nixpkgs.lib.pipe desktops [
          (builtins.map
            (hostname: {
              name = "austin@${hostname}";
              value = home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.x86_64-linux;
                extraSpecialArgs =
                  baseExtraSpecialArgs
                  // {
                    inherit hostname;
                  };
                modules = [
                  ./modules
                  ./users/austin
                ];
              };
            }))
          builtins.listToAttrs
        ]
        // nixpkgs.lib.pipe servers [
          (builtins.map
            (hostname: {
              name = "txn@${hostname}";
              value = home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.x86_64-linux;
                extraSpecialArgs =
                  baseExtraSpecialArgs
                  // {
                    inherit hostname;
                  };
                modules = [
                  ./modules
                  ./users/txn/server.nix
                ];
              };
            }))
          builtins.listToAttrs
        ]
        // nixpkgs.lib.pipe desktops [
          (builtins.map
            (hostname: {
              name = "txn@${hostname}";
              value = home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.x86_64-linux;
                extraSpecialArgs =
                  baseExtraSpecialArgs
                  // {
                    inherit hostname;
                  };
                modules = [
                  ./modules
                  ./users/txn/desktop.nix
                ];
              };
            }))
          builtins.listToAttrs
        ];
    };
}
