# ./home/programs/nixvim.nix

# For configuring Nixvim

{ lib, pkgs, ... }:
{
    plugins = {
        nix.enable = true;                  # enable syntax highlighting for *.nix files
        lightline.enable = true;            # fancy status line
        lspconfig.enable = true;            # install default configs for many language servers
        lastplace.enable = true;
    };

    opts = {
        clipboard = "unnamedplus";          # always use system clipboard

        # Appearance Options
        number = true;                      # show line numbers
        relativenumber = true;              # show relative line numbers
        ruler = true;                       # show current position of cursor in bottom right corner
        wrap = false;                       # don't wrap; allow lines to extend as far as needed

        # Formatting Options
        autoindent = true;
        expandtab = true;
        tabstop = 2;
        shiftwidth = 2;

        # Search & History Options
        incsearch = true;                   # start highlighting results as soon as you start typing
        hlsearch = true;                    # highlight results when searching
        history = 700;                      # remember much further into the past

    };
}
