# environment/media/davinci-resolve.nix

#-----------------------------------#
#  DaVinci Resolve (Video Editing)  #
#-----------------------------------#

# HM-only, gated on the "filmmaker" role: installs DaVinci Resolve, Blackmagic's
# proprietary pro NLE (editing, color, Fairlight audio). Unfree; the flake's pkgs
# already set allowUnfree. Runs on the RTX 3090 via CUDA.
#
# Two caveats for daily use (both product/session limits, not Nix issues):
#   - The free Linux build can't decode/encode H.264/H.265/AAC -- transcode
#     source to an intermediate (DNxHR/ProRes) via ffmpeg (Studio lifts this).
#   - No native Wayland backend; under Plasma Wayland it runs via XWayland, the
#     least-reliable path on Nvidia. Log into a Plasma X11 session for grading.
# Kdenlive (see kdenlive.nix) is the native-Wayland, full-codec alternative.

{ config, pkgs, lib, ... }:

let
  isFilmmaker = builtins.elem "filmmaker" config.userSettings.role;
in {
  config = lib.mkIf isFilmmaker {
    home.packages = [ pkgs.davinci-resolve ];
  };
}
