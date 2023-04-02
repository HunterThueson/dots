#  ./.nixos/sys/nvidia.nix
#
#  ---------------------------------
#  |  Nvidia Configuration Options |
#  ---------------------------------
#

{ config, pkgs, ... }:

let
    inherit pkgs;
in

{

services.xserver.videoDrivers = [ "nvidia" ];
hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
    driSupport32Bit = true;
    extraPackages32 = with pkgs.pkgsi686Linux; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
};

hardware.nvidia = {
    prime = {
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
        sync.enable = true;
        sync.allowExternalGpu = true;
    };
    modesetting.enable = true;      # Fix screen tearing w/ Optimus via PRIME
    nvidiaSettings = true;          # Add `nvidia-settings` to system packages
};

systemd.services.nvidia-control-devices = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart = "${pkgs.linuxPackages.nvidia_x11.bin}/bin/nvidia-smi";
};

boot = {
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
    kernelParams =
        [
            "acpi_rev_override"
            "mem_sleep_default=deep"
            "intel_iommu=igfx_off"
            "nvidia-drm.modeset=1"
        ];
};

} # EOF

