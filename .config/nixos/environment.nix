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
      git                                               # version control utility
      gh                                                # GitHub CLI

  # Vim/Neovim configuration file:
      (import ./vim.nix)

  # NVIDIA driver configuration dependencies
      pciutils
      file
      gnumake
      gcc
      cudatoolkit

  # X11 tools
      xclip                                             # using `xclip -selection c` adds standard input to the clipboard
      xorg.xdpyinfo                                     # get information about X display(s)

  # Terminal
      alacritty                                         # GPU-accelerated terminal emulator
      starship                                          # blazing fast, highly customizable prompt for any shell
      tldr                                              # quickly summarize command usage
      exa                                               # modern replacement for `ls` written in Rust
      ripgrep                                           # modern replacement for `grep` written in Rust
      killall                                           # kill programs with ease
      fd                                                # modern replacement for `find` written in Rust
      parted                                            # CLI partition management
      unzip                                             # extract stuff / unzip file archive
      ffmpeg_5-full                                     # video transcoding utility (and a dependency for many other programs)

  # Terminal: Media/Entertainment
      cmatrix                                           # look like freakin' HACKERMAN (so powerful he could hack time itself)
      neo-cowsay                                        # `cowsay` rewritten in Go (with bonus features!)
      imagemagick                                       # image editing tools for the command line
      yt-dlp                                            # `youtube-dl` fork; download videos from websites like YouTube

  # System info/monitoring
      neofetch                                          # display system info
      gtop                                              # graphical `top`
      btop                                              # another fancy `top`

  # GUI
      polybarFull                                       # a fast and easy-to-use tool for creating status bars
      gparted                                           # GUI partition management
      pcmanfm                                           # lightweight graphical file manager
      firefox                                           # web browser
      mailspring                                        # email client
      discord                                           # chat client
      kate                                              # KDE graphical text editor
      speedcrunch                                       # calculator
      libsForQt5.sddm-kcm                               # add SDDM theme management to KDE Settings Menu

  # GUI: Media/Entertainment
      mpv                                               # video playback
      spotify                                           # music
      gimp-with-plugins                                 # GNU Image Manipulation Program
          gimpPlugins.gmic                              # GIMP plugin for the G'MIC image processing framework
      davinci-resolve                                   # high quality NLE + industry-standard color grading software
      runelite                                          # old-ass game for nostalgic masochists with nothing better to do (like me)
      calibre                                           # ebook client

  # the Rust programming language
      cargo                                             # downloads your Rust project's dependencies and builds your project
      rustup                                            # the Rust toolchain installer
      rustc                                             # the Rust language itself
      rustfmt                                           # a tool for formatting Rust code according to style guidelines

  # Networking
      wget                                              # download files from the command line
      iw                                                # show & manipulate wireless devices

  # Hardware utilities
      openrgb                                           # open source RGB lighting control utility

  # Support for Bluetooth
      bluez                                             # API/Software suite for Bluetooth on Linux
      blueman                                           # GTK+ Bluetooth management frontend

  # Misc dependencies
      libsecret                                         # dependency for mailspring
      binutils                                          # dependency for `make`
      xorriso                                           # dependency for `make iso`
      libsForQt5.qtstyleplugin-kvantum                  # dependency for Kvantum (KDE themes)

  ];

  # Enable all bluez plugins
  hardware.bluetooth.package = pkgs.bluezFull;

}

