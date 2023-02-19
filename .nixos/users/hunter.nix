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
        #
        # user-level package management goes here
        #
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

