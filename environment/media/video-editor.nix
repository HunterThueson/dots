# environment/media/video-editor.nix

#---------------------------#
#  Video Editing Software   #
#---------------------------#

# Enable/disable video editing software

# Current selection: Kdenlive

{ config, pkgs, lib, ... }:

let
  isFilmmaker = builtins.elem "filmmaker" config.userSettings.role;
in {
  config = lib.mkIf isFilmmaker {
    home.packages = [ pkgs.kdePackages.kdenlive ];
  };
}
