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
      libsecret					# dependency for mailspring
      wget
      neofetch					# display system info
      gtop					# graphical `top`
      unclutter					# hides desktop cursor after n amount of time

    # Tools
      vim					# text editor
      alacritty					# terminal emulator
      speedcrunch				# Calculator
      git					# version control
      gh					# GitHub CLI

    # Programs
      firefox					# web browser
      spotify					# music
      mailspring				# email client
      discord					# chat client

    # Media Playback/Editing
      mpv					# video playback
      ffmpeg					# video transcoding utility
      imagemagick				# image editing tools
      yt-dlp					# youtube-dl fork
      gimp					# image editor

    # Games
      runelite					# Old School Runescape
      cmatrix					# look like a freakin' hacker

  ];

  # Enable gnome keyring (mailspring dependency)
  services.gnome3.gnome-keyring.enable = true;
}
