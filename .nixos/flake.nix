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

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

#############
#  Outputs  #
#############

  outputs = inputs @ { self, nixpkgs, home-manager, nixvim, ... }:

  let
    system = "x86_64-linux";
    inherit (nixpkgs) lib;
  in 
  {

    nixosConfigurations = {

    # My home desktop PC
      the-glass-tower = lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };                            # pass flake inputs to all submodules
        modules = [

          # Quick and dirty fix (WIP)
          ./configuration.nix                                         # Band-aid fix to keep the config working until I modularize
          ./environment.nix                                           # band-aid #2

          # System modules
          ./system/hardware/the-glass-tower.nix                       # Hardware config for desktop PC
          ./system/hardware/GPU/nvidia.nix                            # Nvidia GPU configuration
          ./system/display/sddm.nix                                   # SDDM configuration
          ./system/display/xorg.nix                                   # Enable dual monitor setup (hopefully)

          # Home Manager
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;                        # make sure NixOS and Home Manager are using the same `nixpkgs`
            home-manager.useUserPackages = true;                      # enable installation of user packages
            home-manager.extraSpecialArgs = { inherit inputs; };      # pass flake inputs to all modules
            home-manager.backupFileExtension = "backup";              # move existing files by appending ext. instead of throwing errors

            home-manager.sharedModules = [
              ( import ./home/standard-config.nix )
            ];

            # User modules
            home-manager.users.hunter.imports = [
              ./home/hunter.nix
            ];

            home-manager.users.ash.imports = [
              ./home/ash.nix
            ];
          }

          # Nixvim
          nixvim.nixosModules.nixvim
          {
            programs.nixvim = {
              enable = true;
              defaultEditor = true;
              viAlias = true;
              vimAlias = true;
              imports = [ ./home/programs/nixvim.nix ];
            };
          }
        ];
      };
    };
  };
}
