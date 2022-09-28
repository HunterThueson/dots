# ~/.config/nixos/configuration.nix

{ config, pkgs, ... }:

{
    imports = 
        [
            <home-manager/nixos>                                                # Enable the NixOS Home Manager Module
            ./hardware-configuration.nix                                        # include the results of the hardware scan
            ./users.nix                                                         # for user definitions
            ./packages.nix                                                      # for package management
        ];

    boot = {

        kernelParams =
            [
                "acpi_rev_override"
                "mem_sleep_default=deep"
                "intel_iommu=igfx_off"
                "nvidia-drm.modeset=1"
            ];

        kernelPackages = pkgs.linuxPackages_latest;                             # Use the latest LTS Linux kernel
        extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

        loader = {
            efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot/efi";
            };
            grub = {                                                            # Use the GRUB 2 boot loader
                enable = true;
                device = "nodev";
                efiSupport = true;
                version = 2;
                useOSProber = true;
                configurationLimit = 5;                                         # Limit the number of GRUB menu entries
            };
        };
    };

    time = {
        timeZone = "America/Denver";                                            # Set your time zone.
        hardwareClockInLocalTime = true;                                        # Keep the hardware clock in local time instead of UTC
    };                                                                          # for compatibility with Windows Dual Boot

    networking = {
        networkmanager.enable = true;                                           # Enables networking via NetworkManager
        hostName = "the-glass-tower";
        useDHCP = false;
        interfaces = {
            enp4s0f1.useDHCP = true;
            wlp3s0.useDHCP = true;
        };
    };

# Font configuration
  fonts = {
    fontDir.enable = true;                                                # Enable /nix/var/nix/profiles/system/sw/share/X11/fonts
    fonts = with pkgs; [
        (nerdfonts.override {
            fonts = [
                "FiraCode"
                "DroidSansMono"
                "FiraMono"
                "Hack"
                "Arimo"
                "iA-Writer"                                                     # AKA iM-Writing
            ]; 
        })
    ];
    fontconfig.defaultFonts = {
        monospace = [ "FiraCode Nerd Font" ];
    };
  };

# Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
    };

# XServer settings
    services.xserver = {
        enable = true;                                                          # Enable the X11 windowing system
        layout = "us";                                                          # Configure X11 keymap layout
        # libinput.enable = true;                                               # Enable touchpad support (if necessary)

        displayManager = {
            sddm.enable = true;                                                 # Enable SDDM display manager
            sddm.autoNumlock = true;                                            # Enable Numlock on startup
        };

        desktopManager.plasma5.enable = true;                                   # Enable the KDE Plasma 5 desktop environment
    };

# Enable proprietary NVIDIA drivers
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.opengl = {
        enable = true;
        driSupport = true;
        extraPackages = with pkgs; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
        driSupport32Bit = true;
        extraPackages32 = with pkgs.pkgsi686Linux; [ vaapiIntel libvdpau-va-gl vaapiVdpau ];
    };
    hardware.nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        modesetting.enable = true;                                              # Should fix screen tearing w/ Optimus via PRIME
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

    services.xserver.screenSection = ''                                         # Fix screen tearing with Nvidia proprietary drivers (?)
        Option      "metamodes" "nvidia-auto-select +0+0 {ForceCompositionPipeline=On}"
    '';

# Enable CUPS to print documents
    services.printing.enable = true;

# Enable sound
    sound.enable = true;
    hardware.pulseaudio.enable = true;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  # Did you read the comment?
    system.stateVersion = "21.11";

}
