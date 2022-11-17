# ~/.config/nixos/configuration.nix

{ config, pkgs, ... }:

{
    imports = 
        [
            ./hardware-configuration.nix                                        # include the results of the hardware scan
            ./users/setup.nix                                                   # for user definitions
            ./environment.nix                                                   # for system-wide package management and environment configuration
            ./xorg.nix                                                          # for managing XRandR & X Server settings
        ];

    boot = {

        kernelParams =
            [
                "acpi_rev_override"
                "mem_sleep_default=deep"
                "intel_iommu=igfx_off"
                "nvidia-drm.modeset=1"
            ];

        kernelPackages = pkgs.linuxPackages;                                    # Use the default, stable Linux kernel
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

                # Enable Memtest86 (unfree) EFI-compatible system diagnostics utility
                extraFiles = {
                    "memtest86.efi" = "${pkgs.memtest86-efi}/BOOTX64.efi";
                };
                extraEntries = ''
                    menuentry "Memtest86" {
                        chainloader @bootRoot@/memtest86.efi
                    }
                '';

                version = 2;
                useOSProber = true;
                configurationLimit = 25;                                        # Limit the number of GRUB menu entries
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
    };

# Font configuration
  fonts = {
    fontDir.enable = true;                                                      # Enable /nix/var/nix/profiles/system/sw/share/X11/fonts
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
        libinput.enable = true;                                                 # Enable touchpad support
        libinput.mouse.accelProfile = "flat";                                   # Disable pesky mouse acceleration
        exportConfiguration = true;                                             # Symlink the X server configuration under /etc/X11/xorg.conf
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
        prime = {
            intelBusId = "PCI:0:2:0";
            nvidiaBusId = "PCI:1:0:0";
            sync.enable = true;
            sync.allowExternalGpu = true;
        };
        modesetting.enable = true;                      # Should fix screen tearing w/ Optimus via PRIME
        nvidiaSettings = true;                          # Add `nvidia-settings`, NVIDIA's GUI configuration tool, to system packages
    };
    systemd.services.nvidia-control-devices = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig.ExecStart = "${pkgs.linuxPackages.nvidia_x11.bin}/bin/nvidia-smi";
    };

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
