#  ~/.nixos/flake.nix
#
#  ####################################################
#  #  Hunter Thueson's NixOS System Configuration(s)  #
#  ####################################################
#
#  for high-level management of my NixOS system configuration(s) and their
#  dependencies
#

{
    description = "Hunter Thueson's NixOS System Configuration";

############
#  Inputs  #
############

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
        home-manager = {
            url = "github:nix-community/home-manager/release-22.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

#############
#  Outputs  #
#############

    outputs = inputs @ { self, nixpkgs, home-manager, ... }:

    let
        system = "x86_64-linux";

        pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;      # Enable proprietary software
            overlays = [];
        };

        inherit (nixpkgs) lib;
    in

    {
        nixosConfigurations = {
            the-glass-tower = lib.nixosSystem {
                inherit system;
                modules = [
                    (import ./configuration.nix inputs)
                    home-manager.nixosModules.home-manager {
                        home-manager = {
                            useGlobalPkgs = true;
                            useUserPackages = true;

                            # Arguments to be passed to each `[user].nix` file
                            extraSpecialArgs = {
                                inherit pkgs;
                            };

                            # User configuration(s)
                            users = {
                                hunter = import ./users/hunter.nix;
                            };
                        };
                    }
                ];
            };
        };
    };
}
