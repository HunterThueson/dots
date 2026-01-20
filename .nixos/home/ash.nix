# ./home/ash.nix
#
# User configuration file for: Ash
#

{ config, pkgs, inputs, ... }:

{
  home.username = "ash";
  home.homeDirectory = "/home/ash";

  ###########################
  ##  Shell Configuration  ##
  ###########################

  programs.bash = {
    enable = true;

    # Add .bashrc configuration here if needed
    bashrcExtra = ''
    '';

  };

  home.sessionPath = [                  # Extra directories to add to PATH
    "$HOME/bin/nail-clipper/"
  ];

  programs.git = {
    enable = false;
  };

  #############################
  ##  Package Configuration  ##
  #############################

  home.packages = with pkgs; [
    firefox                             # web browser
    spotify                             # music
    mailspring                          # email client
    gimp-with-plugins                   # GNU Image Manipulation Program
      gimpPlugins.gmic                  # GIMP plugin for the G'MIC image processing framework
    mpv                                 # video playback
    imagemagick                         # image editing tools for the command line
    yt-dlp                              # `youtube-dl` fork; download videos from websites like YouTube
    speedcrunch                         # calculator
  ];
  
  ################
  ##  Services  ##
  ################

  services = {
    unclutter = {
      enable = true;
      extraOptions = [ "timeout 1" "ignore-scrolling" ];
    };
  };
}
  
