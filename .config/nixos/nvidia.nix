# ~/.config/nixos/nvidia.nix

{ config, pkgs, ... }:

{
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

    services.xserver.videoDrivers = [ "nvidia" ];
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
        pciutils
        file
        gnumake
        gcc
        cudatoolkit
    ]; 

    hardware.opengl = {
        enable = true;
        driSupport = true;
        extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
        driSupport32Bit = true;
        extraPackages32 = with pkgs.pkgsi686Linux; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
    };

    hardware.nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        modesetting.enable = true;						# Should fix screen tearing w/ Optimus via PRIME
        prime = {
            intelBusId = "PCI:0:2:0";
            nvidiaBusId = "PCI:1:0:0";
            sync.enable = true;
            sync.allowExternalGpu = true;
        };
    };

    systemd.services.nvidia-control-devices = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig.ExecStart = "${pkgs.linuxPackages.nvidia_x11.bin}/bin/nvidia-smi";
    };

  # Fix screen tearing (hopefully)
    services.xserver.screenSection = ''
        Option		"metamodes" "nvidia-auto-select +0+0 {ForceCompositionPipeline=On}"
    '';
}
