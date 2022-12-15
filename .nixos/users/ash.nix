# ~/.nixos/users/ash.nix
#
# User configuration file for: Ash
#

{ config, pkgs, ... }:

{

nixpkgs.config.allowUnfree = true;

# Must be declared per user and changed for each new version of NixOS (per guy on Discord)
home.stateVersion = "22.11";

# Extra directories to add to PATH
home.sessionPath = [
    "$HOME/.cargo/bin/"
    "$HOME/bin/"
    "$HOME/bin/nail-clipper/"
    "$HOME/lib/bash-tome/"
];

home.packages = with pkgs; [
    firefox                 # web browser
    spotify                 # music
    mailspring              # email client
    kate                    # KDE graphical text editor
    gimp-with-plugins       # GNU Image Manipulation Program
        gimpPlugins.gmic    # GIMP plugin for the G'MIC image processing framework
    cmatrix                 # look like freakin' HACKERMAN (so powerful he could hack time itself)
    mpv                     # video playback
    ffmpeg                  # video transcoding utility (and a dependency for many other programs)
    imagemagick             # image editing tools for the command line
    yt-dlp                  # `youtube-dl` fork; download videos from websites like YouTube
    speedcrunch             # calculator
];

########################
## Bash Configuration ##
########################

programs.bash = {
    enable = true;
    historyFile = "$HOME/docs/.bash_history";         # Location of the bash history file
    historyIgnore = [                                 # List of commands that should not be saved to the history list
        "ls"
        "exa"
        "cd"
        "exit"
        "clear"
    ];
    sessionVariables = {                              # Environment variables that will be set for the Bash session
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_CACHE_HOME = "$HOME/.cache";
        STARSHIP_CONFIG = "$XDG_CONFIG_HOME/starship.toml";
        STARSHIP_CACHE = "$XDG_CACHE_HOME/starship";
    };

    ###############
    ## ~/.bashrc ##
    ###############

    bashrcExtra = ''
        # Source session variables file
        . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"

        # Enable Starship prompt
        eval "$(starship init bash)"

        # Teleport to $HOME
        cdd () {
            cd $HOME
            clear
            sleep 0.01
            exa -xDG --icons
        }

        # Teleport to ~/.config
        cdc () {
            cd $HOME/.config
            clear
            exa -D --icons
        }

        # Teleport to NixOS configuration directory
        cdn () {
            cd $HOME/.nixos/
            clear
            exa --icons
        }
    '';

    ###################
    ## Shell Options ##
    ###################

    shellOptions = [
        # Append to history file rather than replacing it
        "histappend"

        # Check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
        "checkwinsize"

        # Extended globbing
        "extglob"
        "globstar"

        # Warn if closing shell with running jobs
        "checkjobs"
    ];

    #####################
    ## ~/.bash_aliases ##
    #####################
    shellAliases = {
        # Drop-in program replacements
        ls = "exa -G --color=always --icons";                                # replace `ls` with `exa` (faster, written in Rust)
        find = "fd";                                                         # replace `find` with `fd` (faster, written in -- you guessed it -- Rust)
        
        # Navigation
        lsa = "exa -Gau --git --time-style long-iso --color=always --icons"; # more info about hidden files (w/ git status)
        lsd = "exa -D --color=always --icons";                               # list only directories
        ghs = "git status";       

        # Terminal clearing
        cl = "clear";                                                        # because typing `clear` just takes too long
    };

};

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

