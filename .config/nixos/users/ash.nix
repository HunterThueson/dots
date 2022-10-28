# ~/.config/nixos/users/ash.nix
# User configuration file for: Ash

{ config, pkgs, ... }:

{

nixpkgs.config.allowUnfree = true;

home.packages = with pkgs; [
    firefox                 # web browser
    spotify                 # music
    mailspring              # email client
    kate                    # KDE graphical text editor
    gimp                    # GNU Image Manipulation Program
    cmatrix                 # look like freakin' HACKERMAN (so powerful he could hack time itself)
    mpv                     # video playback
    ffmpeg                  # video transcoding utility (and a dependency for many other programs)
    imagemagick             # image editing tools for the command line
    yt-dlp                  # `youtube-dl` fork; download videos from websites like YouTube
    speedcrunch             # calculator
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
