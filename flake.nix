{
  description = "home manager flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
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
      # url = "github:nix-community/neovim-nightly-overlay/06556188ee8c7ddfbe7b39d652cf409d0f912705";
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
    servers = [
      {
        hostname = "cloudlab";
        system = "x86_64-linux";
      }
    ];
    desktops = [
      {
        hostname = "x1-carbon";
        system = "x86_64-linux";
      }
      {
        hostname = "ghost-s1";
        system = "x86_64-linux";
      }
    ];
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
            (host: {
              name = "austin@${host.hostname}";
              value = home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.${host.system};
                extraSpecialArgs =
                  baseExtraSpecialArgs
                  // {
                    hostname = host.hostname;
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
            (host: {
              name = "txn@${host.hostname}";
              value = home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.${host.system};
                extraSpecialArgs =
                  baseExtraSpecialArgs
                  // {
                    hostname = host.hostname;
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
            (host: {
              name = "txn@${host.hostname}";
              value = home-manager.lib.homeManagerConfiguration {
                pkgs = nixpkgs.legacyPackages.${host.system};
                extraSpecialArgs =
                  baseExtraSpecialArgs
                  // {
                    hostname = host.hostname;
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
