# ./system/services/nix-config.nix

  ##########################################
  #  Nix Language & Nixpkgs Configuration  #
  ##########################################

{ config, pkgs, inputs, ... }:

{

  ###############################
  #  Nix/Nixpkgs/NixOS options  #
  ###############################

  # Allow unfree/proprietary software
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "mbedtls-2.28.10"
  ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];                       # Enable Flakes
      auto-optimise-store = true;                                               # Automatically optimise nix-store
    };

    # Change where NixOS looks for configuration.nix (this doesn't really matter if we use Flakes)
    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=/home/hunter/.nixos/configuration.nix"                      # this is the only line that doesn't match default `nix.nixPath` value
      "/nix/var/nix/profiles/per-user/root/channels"
    ];

    # Automatic garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 90d";
    };
  };

}
