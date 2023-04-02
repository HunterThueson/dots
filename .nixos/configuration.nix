# ./.nixos/configuration.nix

{ nixpkgs, home-manager, ... }:
{ config, pkgs, ... }:
{

  ###############################
  #  Nix/Nixpkgs/NixOS options  #
  ###############################

    # Allow unfree/proprietary software
    nixpkgs.config.allowUnfree = true;

    nix = {
        settings = {
            experimental-features = [ "nix-command" "flakes" ];                 # Enable Flakes
            auto-optimise-store = true;                                         # Automatically optimise nix-store
        };

        # Change where NixOS looks for configuration.nix
        nixPath = [
            "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
            "nixos-config=/home/hunter/.nixos/configuration.nix"                     # this is the only line that doesn't match default `nix.nixPath` value
            "/nix/var/nix/profiles/per-user/root/channels"
        ];

        # Automatic garbage collection
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 14d";
        };
    };


  #############
  #  Imports  #
  #############

    imports = 
        [
            ./modules/hardware-configuration.nix                                # include the results of the hardware scan
            ./modules/xorg.nix                                                  # for managing XRandR & X Server settings
            ./sys/nvidia.nix                                                    # enable NVIDIA proprietary drivers
            ./environment.nix                                                   # for system-wide package management and environment configuration
        ];

  ########################
  #  Bootloader options  #
  ########################

    boot = {
        kernelPackages = pkgs.linuxPackages;                                    # Use the default, stable Linux kernel
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
                configurationLimit = 10;                                        # Limit the number of GRUB menu entries
            };
        };
    };

  ##############################
  #  Time/clock configuration  #
  ##############################

    time = {
        timeZone = "America/Denver";                                            # Set your time zone.
        hardwareClockInLocalTime = true;                                        # Keep the hardware clock in local time instead of UTC
    };                                                                          # for compatibility with Windows Dual Boot

  ########################
  #  Networking options  #
  ########################

    networking = {
        networkmanager.enable = true;                                           # Enables networking via NetworkManager
        hostName = "the-glass-tower";
        useDHCP = false;
    };

  ########################
  #  Font configuration  #
  ########################

    fonts = {
        fontDir.enable = true;                                                  # Enable /nix/var/nix/profiles/system/sw/share/X11/fonts
        fonts = with pkgs; [
            (nerdfonts.override {
                fonts = [
                    "FiraCode"
                    "DroidSansMono"
                    "FiraMono"
                    "Hack"
                    "Arimo"
                    "iA-Writer"                                                 # AKA iM-Writing
                ]; 
            })
        ];
        fontconfig.defaultFonts = {
            monospace = [ "FiraCode Nerd Font" ];
        };
    };

  #####################################
  #  Internationalisation properties  #
  #####################################

    i18n.defaultLocale = "en_US.UTF-8";
    console = {
        font = "Lat2-Terminus16";
        keyMap = "us";
    };

  ######################
  #  XServer settings  #
  ######################

    services.xserver = {
        enable = true;                                                          # Enable the X11 windowing system
        layout = "us";                                                          # Configure X11 keymap layout
        libinput.enable = true;                                                 # Enable touchpad support
        libinput.mouse.accelProfile = "flat";                                   # Disable pesky mouse acceleration
        exportConfiguration = true;                                             # Symlink the X server configuration under /etc/X11/xorg.conf
        desktopManager.plasma5.enable = true;                                   # Enable the KDE Plasma 5 desktop environment
    };

  ###################
  #  User settings  #
  ###################
  users = {
      mutableUsers = false;
      users = {
          hunter = {
              description = "Hunter";
              isNormalUser = true;
              home = "/home/hunter";
              createHome = true;
              extraGroups = [ "wheel" "video" "networkmanager" "wizard" ];
              hashedPassword = "$6$rounds=500000$ilzR8OoFwfvEOzfO$iJ9QJzjIINDW8ON33jTIIxe/B2XcB3MnCR7/qaA6NC2Sw6efZvX2HJ4l3vif8/ggmAv/4GutT8Xt4/wAgLW0H.";
          };
          ash = {
              description = "Ash";
              isNormalUser = true;
              home = "/home/ash";
              createHome = true;
              extraGroups = [ "wheel" "video" "networkmanager" "wizard" ];
              hashedPassword = "$6$rounds=9999999$FThVWftaj3S0ShgC$C2HOgr7dst7/rnTy2NhLt5aiOOifhZ4cvg1XZ513VBMvxNg3fUGdH/ajdlnSHSKoxSpfoN84EqD3f6cOSL2/y.";
          };
      };
  };

  ###################
  #  Sound options  #
  ###################

    sound.enable = true;
    hardware.pulseaudio.enable = true;

  #####################
  #  Printer options  #
  #####################

    services.printing.enable = true;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  # Did you read the comment?
    system.stateVersion = "21.11";

}

