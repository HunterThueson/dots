# /etc/nixos/user-config.nix

## This file is for separating user management logic from the main configuration.nix file.
## Don't forget to run `passwd` for each user during initialization.

{ config, pkgs, ... }:

{
  users.users = {

    hunter = {
      isNormalUser = true;
      home = "/home/hunter";
      description = "Hunter";
      extraGroups = [ "wheel" "networkmanager" ]; 	# Enable `sudo` for the user.
    };

    ash = {
      isNormalUser = true;
      home = "/home/ash";
      description = "Ash";
      extraGroups = [ "networkmanager" ];
    };

  };

}
