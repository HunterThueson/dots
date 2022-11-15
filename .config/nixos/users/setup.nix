# ~/.config/nixos/users/setup.nix

# This file is for separating user management logic from the main configuration.nix file.
# Don't forget to run `passwd` for each user during initialization.

################
#  User setup  #
################

let
    home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in

{ config, pkgs, ... }:

{
    imports = [
        (import "${home-manager}/nixos")        # enable Home Manager as a NixOS module
    ];

    users = {

    ######################
    #  User definitions  #
    ######################
        users = {
            hunter = {
              isNormalUser = true;
              home = "/home/hunter";
              description = "Hunter";
              extraGroups = [ "wheel" "video" "networkmanager" "wizard" ];      # Enable `sudo` for the user.
            };
        
          # Secondary user account
            ash = {
              isNormalUser = true;
              home = "/home/ash";
              description = "Ash";
              extraGroups = [ "wheel" "video" "networkmanager" "wizard" ];      # Enable `sudo` for the user.
            };
        };

    ##################################
    #  Options applied to all users  #
    ##################################

        defaultUserShell = pkgs.bash;

    };

    ##############################################
    #  Import user-specific configuration files  #
    ##############################################

    home-manager.users = { 
        hunter = (import ./hunter.nix);
        ash = (import ./ash.nix);
    };

}
