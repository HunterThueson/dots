# /etc/nixos/users.nix

# This file is for separating user management logic from the main configuration.nix file.
# Don't forget to run `passwd` for each user during initialization.

{ config, pkgs, ... }:

{
  users.users = {

  # Primary user account
    hunter = {
      isNormalUser = true;
      home = "/home/hunter";
      description = "Hunter";
      extraGroups = [ "wheel" "video" "networkmanager" "wizard" ]; 		# Enable `sudo` for the user.
    };

  # Secondary user account
    ash = {
      isNormalUser = true;
      home = "/home/ash";
      description = "Ash";
      extraGroups = [ "video" "networkmanager" "wizard" ];
    };

  # Work account
    hthueson = {
      isNormalUser = true;
      home = "/home/hthueson";
      description = "hthueson";
      extraGroups = [ "video" "networkmanager" ];
    };

  };

}
