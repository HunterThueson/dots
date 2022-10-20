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

##############
## Packages ##
##############

  environment.systemPackages = with pkgs; [

  # Import Vim/Neovim configuration file:
      (import ../vim.nix)

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
      neofetch                  # display system info
      gtop                      # graphical `top`
      unclutter-xfixes          # auto-hide cursor with `unclutter` (but better!)

  # Tools
      alacritty                 # GPU-accelerated terminal emulator
      speedcrunch               # calculator
      git                       # version control utility
      gh                        # GitHub CLI
      parted                    # CLI partition management
      gparted                   # GUI partition management
      wget                      # download files from the command line
      iw                        # show & manipulate wireless devices
      killall                   # kill programs with ease
      unzip                     # extract stuff / unzip file archives
      openrgb                   # open source RGB lighting control utility

  # the Rust Programming Language
      cargo                     # downloads your Rust project's dependencies and builds your project
      rustup                    # the Rust toolchain installer
      rustc                     # the Rust language itself
      rustfmt                   # a tool for formatting Rust code according to style guidelines

  # Programs
      firefox                   # web browser
      spotify                   # music
      mailspring                # email client
      discord                   # chat client
      kate                      # KDE text editor
      calibre                   # ebook client

  # Media Playback/Editing
      ffmpeg                    # video transcoding utility (and a dependency for many other programs)
      mpv                       # video playback
      imagemagick               # image editing tools for the command line
      yt-dlp                    # youtube-dl fork; download videos from websites like YouTube
      gimp                      # GNU Image Manipulation Program

  # Games
      runelite                  # Old School Runescape semi-official client
      cmatrix                   # look like a freakin' hacker
      neo-cowsay                # `cowsay` rewritten in Go (with extra features)

  # Misc dependencies
      libsecret                 # dependency for mailspring

  ];

}
