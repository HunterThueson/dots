# ~/.config/nixos/environment.nix
#
# This configuration file is imported by /etc/nixos/configuration.nix, and should contain
# all of the environment configuration and package management logic used in the NixOS
# system configuration. Packages imported in this file will be available to all users
# (including root) by default. User-specific packages should be declared elsewhere.

###############################
#  Environment configuration  #
###############################

{ config, pkgs, ... }:

{

# Enable proprietary/unfree software
  nixpkgs.config.allowUnfree = true;

# Enable Nix Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

# Enable gnome keyring (mailspring dependency)
  services.gnome.gnome-keyring.enable = true;

  environment = {
      variables = { EDITOR = "vim"; };
      shells = with pkgs; [ bash ];
  };

##############
## Packages ##
##############

  environment.systemPackages = with pkgs; [

  # Version control
      git                       # version control utility
      gh                        # GitHub CLI

  # Import Vim/Neovim configuration file:
      (import ./vim.nix)

  # NVIDIA driver configuration dependencies
      pciutils
      file
      gnumake
      gcc
      cudatoolkit

  # X11 tools
      xclip                     # using `xclip -selection c` adds standard input to the clipboard
      xorg.xdpyinfo             # get information about X display(s)

  # Quality of life
      starship                  # blazing fast, highly customizable prompt for any shell
      tldr                      # quickly summarize command usage
      exa                       # modern replacement for `ls` written in Rust
      ripgrep                   # modern replacement for `grep` written in Rust
      fd                        # modern replacement for `find` written in Rust
      polybarFull               # a fast and easy-to-use tool for creating status bars

  # System info/monitoring
      neofetch                  # display system info
      gtop                      # graphical `top`
      btop                      # another fancy `top`

  # Tools
      alacritty                 # GPU-accelerated terminal emulator
      parted                    # CLI partition management
      gparted                   # GUI partition management
      wget                      # download files from the command line
      iw                        # show & manipulate wireless devices
      killall                   # kill programs with ease
      unzip                     # extract stuff / unzip file archives
      pcmanfm                   # lightweight graphical file manager
      openrgb                   # open source RGB lighting control utility

  # the Rust programming language
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

  # Enable all bluez plugins
  hardware.bluetooth.package = pkgs.bluezFull;

}
