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
      nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
      home-manager = {
          url = "github:nix-community/home-manager/release-25.11";
          inputs.nixpkgs.follows = "nixpkgs";
      };
  };

#############
#  Outputs  #
#############

  outputs = inputs @ { self, nixpkgs, home-manager, ... }:

  let
      system = "x86_64-linux";
      inherit (nixpkgs) lib;
  in 
  {

      nixosConfigurations = {

      # My desktop PC

          the-glass-tower = lib.nixosSystem {
              inherit system;
              modules = [                                                       # but I'll use it later

                  (import ./configuration.nix inputs)                           # Band-aid fix to keep the config working until I modularize

                  ######################
                  # Home Manager Setup #
                  ######################

                  home-manager.nixosModules.home-manager
                  {
                      home-manager.useGlobalPkgs = true;
                      home-manager.useUserPackages = true;

                      home-manager.users.hunter.imports = [
                          ./users/common.nix
                          ./users/hunter.nix
                      ];

                      home-manager.users.ash.imports = [
                          ./users/common.nix
                          ./users/ash.nix
                      ];

                  }
              ];
          };

      };
  };
}
