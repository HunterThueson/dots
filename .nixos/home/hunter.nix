# ./home/hunter.nix
#
# User configuration file for: Hunter
#

{ config, pkgs, inputs, ... }:

{
  home.username = "hunter";
  home.homeDirectory = "/home/hunter";

  ###########################
  ##  Shell Configuration  ##
  ###########################

  programs.bash = {
    enable = true;
    bashrcExtra = ''

      # Teleport to NixOS configuration directory
      cdn () {
        cd /home/hunter/.nixos/
        clear
        eza --icons=auto --group-directories-first
      }

      # Teleport to user configuration directory
      cdc () {
        cd /home/hunter/.config/
        clear
        eza --icons=auto --group-directories-first
      }

    '';

  };

  home.sessionPath = [                                      # Extra directories to add to PATH
    "$HOME/bin/nail-clipper/"
  ];

  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "master";
      user.name = "Hunter Thueson";
      user.email = "hunter.thueson@gmail.com";
      core.editor = "vim";
    };
  };

  #############################
  ##  Package Configuration  ##
  #############################

  home.packages = with pkgs; [
    firefox                                                 # web browser
    spotify                                                 # music
    mailspring                                              # email client
    discord                                                 # chat client
    calibre                                                 # ebook client
    gimp-with-plugins                                       # GNU Image Manipulation Program
      gimpPlugins.gmic                                      # GIMP plugin for the G'MIC image processing framework
    cmatrix                                                 # look like freakin' HACKERMAN (so powerful he could hack time itself)
    neo-cowsay                                              # `cowsay` rewritten in Go (with bonus features!)
    mpv                                                     # video playback
    imagemagick                                             # image editing tools for the command line
    yt-dlp                                                  # `youtube-dl` fork; download videos from websites like YouTube
    speedcrunch                                             # calculator
    runelite                                                # third-party client for Old School Runescape (a game for masochists)
    wineWow64Packages.full                                  # fix dependency issue with bolt launcher
    bolt-launcher                                           # third-party client for Jagex Launcher on Linux
    jdk17                                                   # fix dependency issue with bolt launcher
  ];
  
  ################
  ##  Services  ##
  ################

  services = {
    unclutter = {
      enable = true;
      extraOptions = [ "timeout 3" "ignore-scrolling" ];
    };
  };
}
  
