# hosts/hephaestus/configuration.nix

#--------------#
#  Hephaestus  #     AKA     Hunter's Home Desktop PC
#--------------#

# Host-specific configuration. Module imports now come from system/ and environment/
# via mkHosts.nix. This file only contains config unique to this host.

{ config, pkgs, lib, ... }:

{
  time.timeZone = "America/Denver";

  #----------------------#
  #  Networking options  #
  #----------------------#

  networking = {
    hostName = "hephaestus";
  };

  services.openssh = {
    enable = true;
  };

  #-----------------------------------#
  #  Internationalisation properties  #
  #-----------------------------------#

  i18n.defaultLocale = "en_US.UTF-8";
  console.useXkbConfig = true;

  #---------------------#
  #  Hardware Packages  #
  #---------------------#

  environment.systemPackages = with pkgs; [
    lact                                                    # Linux GPU Control Application
    nvtopPackages.full                                      # htop-like task monitor for GPUs
    openrgb                                                 # open source RGB lighting control
    xdpyinfo                                                # get information about X display(s)
    gparted                                                 # GUI partition management
    parted                                                  # CLI partition management
    cryptsetup                                              # disk encryption utilities
  ];

  services.lact.enable = true;

  #---------------#
  #  Environment  #
  #---------------#

  # Firefox 153's native-Wayland fractional scaling renders micro on this host's
  # 4K M28U (KWin scale 1.25); force Mozilla apps to XWayland until upstream
  # fixes it. Hunter's profile bumps devPixelsPerPx to offset XWayland's 1.0.
  environment.sessionVariables.MOZ_ENABLE_WAYLAND = "0";

}
