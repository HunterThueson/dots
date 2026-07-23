# environment/media/kdenlive.nix

#-----------------------------#
#  Kdenlive (Video Editing)   #
#-----------------------------#

# HM-only, gated on the "filmmaker" role: installs Kdenlive, KDE's
# open-source non-linear video editor. Full ffmpeg codec support (opens
# H.264/H.265/MP4 directly, unlike DaVinci Resolve's free Linux build) and
# native to Plasma.

{ config, pkgs, lib, ... }:

let
  isFilmmaker = builtins.elem "filmmaker" config.userSettings.role;
in {
  config = lib.mkIf isFilmmaker {
    home.packages = [ pkgs.kdePackages.kdenlive ];
  };
}
