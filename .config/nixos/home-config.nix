# ~/.config/nixos/home-config.nix

########################
## Home Manager Setup ##
########################

# Note: the following configuration template was shamelessly stolen from https://nixos.wiki/wiki/Home_Manager

{ config, pkgs, ... }:

let
    home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in
{
    imports = [
        (import "${home-manager}/nixos")
    ];

    home-manager.users.hunter = {
        # This is where home-manager configuration goes (e.g. 'home.packages = [ pkgs.foo ];')
    };

    home-manager.users.ash = {
        # It feels weird to be managing all users' configurations in one file; maybe separate this into multiple files at some point?
    };
}
