#  ~/.nixos/flake.nix

   ####################################################
   #  Hunter Thueson's NixOS System Configuration(s)  #
   ####################################################

#  for high-level management of my NixOS system configuration(s) and their
#  dependencies

{
  description = "Hunter Thueson's NixOS System Configuration";

############
#  Inputs  #
############

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
          url = "github:nix-community/home-manager";
          inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
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

    ###########
    #  Hosts  #
    ###########

    nixosConfigurations = {
      the-glass-tower = lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };                            # pass flake inputs to all submodules
        modules = [

        #####################
        #  The Glass Tower  #                                             # my home desktop PC
        #####################

          ./system/hosts/the-glass-tower.nix                          # Per-host entrypoint for host-specific options
          ./system/hardware/the-glass-tower.nix                       # Nix-generated hardware config for this host

          ./environment.nix                                           # band-aid

        ##################
        # System Modules #
        ##################

          ./system/boot/loader.nix                                    # Bootloader configuration

          ./system/hardware/mouse-and-keyboard.nix                    # Mouse and keyboard configuration
          ./system/hardware/GPU/nvidia.nix                            # Nvidia GPU configuration

          ./system/display/sddm.nix                                   # SDDM configuration
          ./system/display/xorg.nix                                   # Enable dual monitor setup (hopefully)
          ./system/display/fonts.nix                                  # Configure system fonts

          ./system/services/nix-config.nix                            # Nix Language & Nixpkgs configuration options

        ################
        # Home Manager #
        ################

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;                        # make sure NixOS and Home Manager are using the same `nixpkgs`
            home-manager.useUserPackages = true;                      # enable installation of user packages
            home-manager.extraSpecialArgs = { inherit inputs; };      # pass flake inputs to all modules
            home-manager.backupFileExtension = "backup";              # move existing files by appending ext. instead of throwing errors

            home-manager.sharedModules = [
              ( import ./home/standard-config.nix )
              ( import ./home/programs/alacritty/alacritty.nix )
            ];

            # User modules
            home-manager.users.hunter.imports = [
              ./home/hunter.nix
            ];

            home-manager.users.ash.imports = [
              ./home/ash.nix
            ];
          }

        ##########
        # Nixvim #
        ##########

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
