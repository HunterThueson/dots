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
    inherit (nixpkgs) lib;

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;      # Enable proprietary software
      overlays = [];
    };

    util = import ./lib {
      inherit system pkgs home-manager lib; overlays = (pkgs.overlays);
    };

    inherit (util) user;
    inherit (util) host;

    system = "x86_64-linux";
  in

  {
      homeManagerConfigurations = {
          hunter = user.mkUser {
              username = "hunter";
              description = "Hunter";
              groups = [ "wheel" "video" "networkmanager" "wizard" ];
              uid = 1000;
              shell = pkgs.bash;
              hashedPassword = "$6$rounds=500000$ilzR8OoFwfvEOzfO$iJ9QJzjIINDW8ON33jTIIxe/B2XcB3MnCR7/qaA6NC2Sw6efZvX2HJ4l3vif8/ggmAv/4GutT8Xt4/wAgLW0H.";
          };
      };

      nixosConfigurations = {
        the-glass-tower = lib.nixosSystem {
          inherit system;
          modules = [
            (import ./configuration.nix inputs)

            home-manager.nixosModules.home-manager {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                # User configuration(s)
                users = {
                  hunter = import ./users/hunter.nix;
                  ash = import ./users/ash.nix;
                };
              };
            }

          ];
        };
      };

  };
}
