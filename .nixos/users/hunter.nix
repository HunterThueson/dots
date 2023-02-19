# ./users/hunter.nix
#
# User configuration file for: Hunter
#

{ pkgs, ... }:

{
    imports = [ ./common.nix ];

    ###########################
    ##  Shell Configuration  ##
    ###########################

    programs.bash.enable = true;

    home.sessionPath = [                    # Extra directories to add to PATH
        "$HOME/bin/nail-clipper/"
        "$HOME/lib/bash-tome/"
    ];

    #############################
    ##  Package Configuration  ##
    #############################

    home.packages = with pkgs; [
        firefox                     # web browser
        spotify                     # music
        mailspring                  # email client
        runelite                    # game for masochists
        discord                     # chat client
        kate                        # KDE graphical text editor
        calibre                     # ebook client
        gimp-with-plugins           # GNU Image Manipulation Program
            gimpPlugins.gmic        # GIMP plugin for the G'MIC image processing framework
        cmatrix                     # look like freakin' HACKERMAN (so powerful he could hack time itself)
        neo-cowsay                  # `cowsay` rewritten in Go (with bonus features!)
        mpv                         # video playback
        imagemagick                 # image editing tools for the command line
        yt-dlp                      # `youtube-dl` fork; download videos from websites like YouTube
        speedcrunch                 # calculator
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
    
