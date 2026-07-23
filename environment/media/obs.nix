# environment/media/obs.nix

#-------------------------------#
#  OBS Studio (Screen Capture)  #
#-------------------------------#

# Dual-export, gated on the "filmmaker" role:
#   nixos: v4l2loopback kernel module for the OBS virtual camera
#   home:  OBS Studio + plugins per-user
#
# NVENC (Ampere: H.264/HEVC) works on the proprietary Nvidia driver already
# configured in system/hardware/gpu. PipeWire screen capture works under both
# Plasma Wayland (xdg-desktop-portal-kde) and Hyprland (xdg-desktop-portal-hyprland);
# PipeWire and both portals are already enabled elsewhere.

{
  nixos = { config, lib, ... }:
  let
    users = lib.attrValues config.userSettings;
    anyFilmmaker = lib.any (u: builtins.elem "filmmaker" u.role) users;
  in {
    config = lib.mkIf anyFilmmaker {
      # Virtual camera: pipe OBS scenes into Discord/Zoom/browser as a webcam
      boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
      boot.kernelModules       = [ "v4l2loopback" ];
      boot.extraModprobeConfig = ''
        options v4l2loopback devices=1 video_nr=9 card_label="OBS Virtual Camera" exclusive_caps=1
      '';
    };
  };

  home = { config, pkgs, lib, ... }:
  let
    isFilmmaker = builtins.elem "filmmaker" config.userSettings.role;
  in {
    config = lib.mkIf isFilmmaker {
      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          obs-vkcapture               # low-overhead Vulkan/OpenGL game capture (Wayland-friendly)
          obs-pipewire-audio-capture  # per-application audio capture via PipeWire
          input-overlay               # on-screen keyboard/mouse/gamepad overlay
          obs-multi-rtmp              # stream to multiple RTMP targets at once
        ];
      };

      # obs-gamecapture + the Vulkan capture layer on PATH / XDG_DATA_DIRS so games
      # can be launched with `obs-gamecapture %command%` (Steam launch option).
      home.packages = [ pkgs.obs-studio-plugins.obs-vkcapture ];
    };
  };
}
