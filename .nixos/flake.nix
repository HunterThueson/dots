#  ~/.nixos/flake.nix
#  SPDX License Identifier: MIT
#
#  ####################################################
#  #  Hunter Thueson's NixOS System Configuration(s)  #
#  ####################################################
#
#  for high-level management of my NixOS system configuration(s) and their
#  dependencies
#

{

#################
#  Description  #
#################

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
                ];
            };

        };
    };

}
