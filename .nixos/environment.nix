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
  programs.firefox.enable = true;

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
      eza                                               # modern replacement for `ls` written in Rust
      ripgrep                                           # modern replacement for `grep` written in Rust
      killall                                           # kill programs with ease
      fd                                                # modern replacement for `find` written in Rust
      parted                                            # CLI partition management
      unzip                                             # extract stuff / unzip file archive
      ffmpeg_6-full                                     # video transcoding utility (and a dependency for many other programs)

  # System info/monitoring
      neofetch                                          # display system info
      gtop                                              # graphical `top`
      btop                                              # another fancy `top`
      upower                                            # command line util for monitoring mouse battery life

  # GUI
      polybarFull                                       # a fast and easy-to-use tool for creating status bars
      gparted                                           # GUI partition management
      pcmanfm                                           # lightweight graphical file manager
      libsForQt5.sddm-kcm                               # add SDDM theme management to KDE Settings Menu

# the Rust programming language cargo                                             # downloads your Rust project's dependencies and builds your project
      rustup                                            # the Rust toolchain installer
      rustc                                             # the Rust language itself
      rustfmt                                           # a tool for formatting Rust code according to style guidelines

  # Networking
      wget                                              # download files from the command line
      iw                                                # show & manipulate wireless devices
      openvpn                                           # connect to VPN

  # Hardware utilities
      openrgb                                           # open source RGB lighting control utility

  # Misc dependencies
      libsecret                                         # dependency for mailspring
      binutils                                          # dependency for `make`
      xorriso                                           # dependency for `make iso`
      libsForQt5.qtstyleplugin-kvantum                  # dependency for Kvantum (KDE themes)

  # Emacs
      emacs

  # Neovim configuration
    (neovim.override {
        viAlias = true;
        vimAlias = true;
        configure = {
    
            ###############
            ### Plugins ###
            ###############
    
            packages.myPlugins = with pkgs.vimPlugins; {
                start = [
                    vim-nix             # enable syntax highlighting for *.nix files
                    vim-lastplace       # intelligently re-open files at the last place you edited them
                    vim-airline         # fancy status line
                    rust-vim            # rust syntax, formatting, rustplay(?)...
                ];
                opt = [];
            };
    
            ###############
            ### Options ###
            ###############
    
            customRC = ''
                set nocompatible                            " Disable vi compatibility mode as it can sometimes cause issues
                set backspace=indent,eol,start              " Ensures that backspace behavior will function as expected
                
                " Filetype Options "
                syntax on                                   " Turn on syntax highlighting for files with a shebang
                filetype on                                 " Enable file type detection
                filetype plugin on                          " Enable plugins and load plugin for the detected file type
                filetype indent on                          " Load an indent file for the detected file type
                
                " Appearance Options "
                set number relativenumber                   " Use hybrid line numbers on the left side of the screen
                set nowrap                                  " Do not wrap; allow long lines to extend as far as needed
                set ruler                                   " Show current position of cursor in bottom right corner

                highlight ColorColumn ctermbg=magenta       " Highlight the 81st column of every line
                call matchadd('ColorColumn', '\%81v', 100)  " ...but only if the line actually extends to line 81
                
                " Search & History Options "
                set incsearch                               " Start highlighting results as soon as you start typing
                set hlsearch                                " Highlight results when searching
                set history=700                             " Remember much further into the past
                
                " Formatting Options "
                set autoindent                              " Automatically indent new lines to match formatting
                set expandtab                               " Convert tabs to corresponding number of spaces
                set tabstop=4                               " Set width of tabs by number of columns
                set shiftwidth=4                            " Manage indentation width when using `>>` or `<<`
    
                " System Integration Options
                set clipboard+=unnamedplus                  " Always use the clipboard for ALL operations (instead of
                                                            " interacting with the '+' and '*' registers explicitly)
            '';
        };
    })

  # Jagex Launcher
    wineWow64Packages.full
    bolt-launcher
    jdk17                                                   # fix dependency issue with bolt launcher

  # Temporary workaround for home-manager weirdness
    spotify
    mailspring
    runelite
    discord
    calibre
    gimp-with-plugins
        gimpPlugins.gmic
    cmatrix
    neo-cowsay
    mpv
    imagemagick
    yt-dlp
    speedcrunch

  # Graphics management software
    nvtopPackages.full

  ];

  # Steam
    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;                     # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true;                # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true;      # Open ports in the firewall for Steam Local Network Game Transfers
    };


  # Enable all bluez plugins
  hardware.bluetooth.package = pkgs.bluezFull;

}
