# ~/.config/nixos/users/hunter.nix
# User configuration file for: Hunter

{ config, pkgs, ... }:

{

nixpkgs.config.allowUnfree = true;

home.packages = with pkgs; [
    firefox                 # web browser
    spotify                 # music
    mailspring              # email client
    runelite                # game for masochists
    discord                 # chat client
    kate                    # KDE graphical text editor
    calibre                 # ebook client
    gimp                    # GNU Image Manipulation Program
    cmatrix                 # look like freakin' HACKERMAN (so powerful he could hack time itself)
    neo-cowsay              # `cowsay` rewritten in Go (with bonus features!)
    mpv                     # video playback
    ffmpeg                  # video transcoding utility (and a dependency for many other programs)
    imagemagick             # image editing tools for the command line
    yt-dlp                  # `youtube-dl` fork; download videos from websites like YouTube
    speedcrunch             # calculator
    unclutter-xfixes        # auto-hide cursor with `unclutter` (but better!)
];

}
