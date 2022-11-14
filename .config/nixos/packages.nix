# ~/.config/nixos/packages.nix

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

# Set default editor
  environment.variables = { EDITOR = "vim"; };

# Add shell(s) to /etc/shells
  environment.shells = with pkgs; [ bash ];

##############
## Packages ##
##############

  environment.systemPackages = with pkgs; [

  # Import Vim/Neovim configuration file:
      (import ./vim.nix)

  # NVIDIA driver configuration dependencies
      pciutils
      file
      gnumake
      gcc
      cudatoolkit

  # Quality of Life
      starship                  # blazing fast, highly customizable prompt for any shell
      tldr                      # quickly summarize command usage
      exa                       # modern replacement for `ls` written in Rust
      fd                        # simple, fast and user-friendly alternative to `find`
      polybarFull               # a fast and easy-to-use tool for creating status bars
      neofetch                  # display system info
      gtop                      # graphical `top`

  # Tools
      alacritty                 # GPU-accelerated terminal emulator
      git                       # version control utility
      gh                        # GitHub CLI
      parted                    # CLI partition management
      gparted                   # GUI partition management
      wget                      # download files from the command line
      iw                        # show & manipulate wireless devices
      killall                   # kill programs with ease
      unzip                     # extract stuff / unzip file archives
      pcmanfm                   # lightweight graphical file manager
      openrgb                   # open source RGB lighting control utility

  # the Rust Programming Language
      cargo                     # downloads your Rust project's dependencies and builds your project
      rustup                    # the Rust toolchain installer
      rustc                     # the Rust language itself
      rustfmt                   # a tool for formatting Rust code according to style guidelines

  # Support for Bluetooth
      bluez                     # API/Software suite for Bluetooth on Linux
      blueman                   # GTK+ Bluetooth management frontend

  # Misc dependencies
      libsecret                 # dependency for mailspring
      binutils                  # dependency for `make`
      xorriso                   # dependency for `make iso`

  # Kvantum (for KDE themes)
      libsForQt5.qtstyleplugin-kvantum
  ];

}
