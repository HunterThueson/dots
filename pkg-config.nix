# /etc/nixos/pkg-config.nix
#
# This configuration file is imported by /etc/nixos/configuration.nix, and should contain
# all of the package management logic used in the NixOS configuration.

{ config, pkgs, ... }:

{

# Enable proprietary/unfree software

  nixpkgs.config = {

      allowUnfree = true;

  };

##############
## Packages ##
##############

  environment.systemPackages = with pkgs; [

    # Utilities
      gnome-keyring				# dependency for mailspring
      libsecret					# dependency for mailspring
      wget
      neofetch
      gtop
      unclutter

    # Tools
      vim
      alacritty
      speedcrunch
      git

    # Programs
      firefox
      spotify
      mailspring
      discord

    # Media Playback/Editing
      mpv
      ffmpeg
      imagemagick
      yt-dlp
      gimp

    # Games
      runelite
      cmatrix

  ];

}
