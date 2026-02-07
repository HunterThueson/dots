# ./.nixos/environment.nix
#
# This configuration file is imported by /etc/nixos/configuration.nix, and should contain
# all of the environment configuration and package management logic used in the NixOS
# system configuration. Packages imported in this file will be available to all users
# (including root) by default. User-specific packages should be declared elsewhere.
#

###############################
#  Environment configuration  #
###############################

{ config, pkgs, ... }:

{

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
    git                                                     # version control utility
    gh                                                      # GitHub CLI

  # NVIDIA driver configuration dependencies
    pciutils
    file
    gnumake
    gcc
    cudatoolkit

  # X11 tools
    xclip                                                   # using `xclip -selection c` adds standard input to the clipboard
    xorg.xdpyinfo                                           # get information about X display(s)

  # Terminal
    alacritty                                               # GPU-accelerated terminal emulator
    starship                                                # blazing fast, highly customizable prompt for any shell
    tldr                                                    # quickly summarize command usage
    eza                                                     # modern replacement for `ls` written in Rust
    ripgrep                                                 # modern replacement for `grep` written in Rust
    killall                                                 # kill programs with ease
    fd                                                      # modern replacement for `find` written in Rust
    parted                                                  # CLI partition management
    unzip                                                   # extract stuff / unzip file archive
    ffmpeg_6-full                                           # video transcoding utility (and a dependency for many other programs)
    instaloader                                             # utility for downloading photos & videos from Instagram

  # System info/monitoring
    neofetch                                                # display system info
    gtop                                                    # graphical `top`
    btop                                                    # another fancy `top`
    upower                                                  # command line util for monitoring mouse battery life

  # GUI
    gparted                                                 # GUI partition management
    pcmanfm                                                 # lightweight graphical file manager

  # the Rust programming language 
    cargo                                                   # downloads your Rust project's dependencies and builds your project
    rustup                                                  # the Rust toolchain installer
    rustc                                                   # the Rust language itself
    rustfmt                                                 # a tool for formatting Rust code according to style guidelines

  # Networking
    wget                                                    # download files from the command line
    iw                                                      # show & manipulate wireless devices
    openvpn                                                 # connect to VPN
  
  # Hardware utilities
    openrgb                                                 # open source RGB lighting control utility
    keymapp                                                 # configure ZSA keyboards (like my Moonlander)
    parted
    cryptsetup

  # Misc dependencies
    libsecret                                               # dependency for mailspring
    binutils                                                # dependency for `make`
    xorriso                                                 # dependency for `make iso`
    libsForQt5.qtstyleplugin-kvantum                        # dependency for Kvantum (KDE themes)

  # Emacs
    emacs

  # Mouse configuration software
    libratbag
    piper

  # Graphics management software
    nvtopPackages.full

  # Old School Runescape                                    # installing at system level to see if that allows access to GPU
    runelite                                                # third-party client for Old School Runescape (a game for masochists)
    wineWow64Packages.full                                  # fix dependency issue with bolt launcher
    bolt-launcher                                           # third-party client for Jagex Launcher on Linux
    jdk17                                                   # fix dependency issue with bolt launcher
  ];

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;                         # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true;                    # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true;          # Open ports in the firewall for Steam Local Network Game Transfers
  };


  # Enable all bluez plugins
  hardware.bluetooth.package = pkgs.bluezFull;

}

