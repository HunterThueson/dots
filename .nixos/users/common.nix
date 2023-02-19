# ./users/common.nix
#
# configuration options to be applied to all users by default
# 

{ pkgs, ... }:

{

# Must be declared per user and changed for each new version of NixOS (per guy on Discord)
home.stateVersion = "22.11";

# Extra directories to add to PATH
home.sessionPath = [
    "/usr/local/bin/"
    "$HOME/bin/"
    "$HOME/.cargo/bin/"
];

############################
## Keyboard Configuration ##
############################

home.keyboard = {
    layout = "us";
    options = [ "caps:backspace" ];
};

########################
## Bash Configuration ##
########################

#  Note: `bash` must be enabled per-user in their respective [user].nix file in
#  order to allow each user to use a different shell (such as `fish` or `zsh`):
#
#     programs.bash.enable = true;
#

programs.bash = {
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

    ###############
    ## ~/.bashrc ##
    ###############

    bashrcExtra = ''
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

        # `gh` wrapper to make listing issues easier
        gh () {
            if [[ $@ == "issue list" ]]; then
                command gh issue list -L 100
            else
                command gh "$@"
            fi
        }

    '';

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

}

