# /etc/nixos/packages.nix

# This configuration file is imported by /etc/nixos/configuration.nix, and should contain
# all of the package management logic used in the NixOS system configuration. Packages
# imported in this file will be available to all users (including root) by default.

####################################################################################################################################
# TODO: separate system-level package configuration from per-user package configuration. For instance, root doesn't need RuneLite! #
####################################################################################################################################

{ config, pkgs, ... }:

{

###################
## Configuration ##
###################

# Enable proprietary/unfree software
  nixpkgs.config.allowUnfree = true;

# Enable gnome keyring (mailspring dependency)
  services.gnome.gnome-keyring.enable = true;

##############
## Packages ##
##############

  environment.systemPackages = with pkgs; [

    # Utilities
      libsecret					# dependency for mailspring
      wget					# download files from the command line
      neofetch					# display system info
      gtop					# graphical `top`
      unclutter					# hides desktop cursor after n amount of time
      iw					# show & manipulate wireless devices
      pciutils

    # Tools
      vim					# text editor
      alacritty					# GPU-accelerated terminal emulator
      speedcrunch				# calculator
      git					# version control utility
      gh					# GitHub CLI
      parted					# CLI partition management
      gparted					# GUI partition management

    # Programs
      firefox					# web browser
      spotify					# music
      mailspring				# email client
      discord					# chat client
      kate					# KDE text editor

    # Media Playback/Editing
      mpv					# video playback
      ffmpeg					# video transcoding utility
      imagemagick				# image editing tools
      yt-dlp					# youtube-dl fork
      gimp					# image editor

    # Games
      runelite					# Old School Runescape semi-official client
      cmatrix					# look like a freakin' hacker

    # New
      killall
      unzip

  ];

}
