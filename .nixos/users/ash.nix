# ./users/ash.nix
#
# User configuration file for: Ash
#

{ pkgs, ... }:

{
    imports = [ ./common.nix ];

    ###########################
    ##  Shell Configuration  ##
    ###########################

    programs.bash.enable = true;

    #############################
    ##  Package Configuration  ##
    #############################

    home.packages = with pkgs; [
        firefox                     # web browser
        spotify                     # music
        mailspring                  # email client
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
            extraOptions = [ "timeout 1" "ignore-scrolling" ];
        };
    };
}
    
