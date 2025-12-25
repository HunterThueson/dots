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

      pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;      # Enable proprietary software
          overlays = [];
      };

      inherit (nixpkgs) lib;

      # util = import ./lib {
          # inherit system pkgs home-manager lib; overlays = (pkgs.overlays);
      # };
      # inherit (util) user;
      # inherit (util) host;

  in 
  {
      #----------------#
      #  User Configs  #
      #----------------#

      homeConfigurations = {

          hunter = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                  ./users/hunter.nix pkgs
              ];
          };

          ash = home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                  ./users/ash.nix pkgs
              ];
          };

      };

      #------------------#
      #  System Configs  #
      #------------------#

      nixosConfigurations = {

      # Desktop PC

          the-glass-tower = lib.nixosSystem {
              inherit system;
              modules = [
                  (import ./configuration.nix inputs)
              ];
          };

      };
  };
}
