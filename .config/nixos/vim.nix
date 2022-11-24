# ~/.config/nixos/vim.nix

###################################
## Vim/Neovim Configuration File ##
###################################

with import <nixpkgs> {};

neovim.override {
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
            set nocompatible                    " Disable vi compatibility mode as it can sometimes cause issues
            set backspace=indent,eol,start      " Ensures that backspace behavior will function as expected
            
            " Filetype Options "
            syntax on                           " Turn on syntax highlighting for files with a shebang
            filetype on                         " Enable file type detection
            filetype plugin on                  " Enable plugins and load plugin for the detected file type
            filetype indent on                  " Load an indent file for the detected file type
            
            " Appearance Options "
            set number relativenumber           " Use hybrid line numbers on the left side of the screen
            set nowrap                          " Do not wrap; allow long lines to extend as far as needed
            set ruler                           " Show current position of cursor in bottom right corner
            
            " Search & History Options "
            set incsearch                       " Start highlighting results as soon as you start typing
            set hlsearch                        " Highlight results when searching
            set history=700                     " Remember much further into the past
            
            " Formatting Options "
            set autoindent                      " Automatically indent new lines to match formatting
            set expandtab                       " Convert tabs to corresponding number of spaces
            set tabstop=4                       " Set width of tabs by number of columns
            set shiftwidth=4                    " Manage indentation width when using `>>` or `<<`

            " System Integration Options
            set clipboard+=unnamedplus          " Always use the clipboard for ALL operations (instead of
                                                " interacting with the '+' and '*' registers explicitly)
        '';
    };
}
