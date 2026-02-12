# ./system/environment/nix-config.nix

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

    # The Hyprland flake is not built by Hydra, so it is not cached in cache.nixos.org like the rest of Nixpkgs.
    # In order to avoid building Hyprland and its dependencies, we can take advantage of a Cachix cache instead
    # for much faster build times/generation switches.
    #
    # This must be enabled BEFORE using the Hyprland flake package.
      substituters = ["https://hyprland.cachix.org"];
      trusted-substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
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
