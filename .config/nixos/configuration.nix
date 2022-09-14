# /etc/nixos/configuration.nix

{ config, pkgs, ... }:

{
    imports = 
        [
            <home-manager/nixos>						# Enable the NixOS Home Manager Module
            ./hardware-configuration.nix					# include the results of the hardware scan
            ./users.nix								# for user definitions
            ./packages.nix							# for package management
            ./nvidia.nix
        ];

    boot = {

        kernelPackages = pkgs.linuxPackages_latest;				# Use the latest LTS Linux kernel

        loader = {
            efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot/efi";
            };
            grub = {								# Use the GRUB 2 boot loader
                enable = true;
                device = "nodev";
                efiSupport = true;
                version = 2;
                useOSProber = true;
		configurationLimit = 5;						# Limit the number of GRUB menu entries
            };
        };
    };

    time = {
        timeZone = "America/Denver";						# Set your time zone.
        hardwareClockInLocalTime = true;					# Keep the hardware clock in local time instead of UTC
    };										# for compatibility with Windows Dual Boot

    networking = {
        networkmanager.enable = true;						# Enables networking via NetworkManager
        hostName = "the-glass-tower";						# (note: NetworkManager & wpa_supplicant are not compatible)

        useDHCP = false;							# The global useDHCP flag is deprecated, therefore explicitly
										# set to false here. Per-interface useDHCP will be mandatory
        interfaces = {								# in the future, so this generated config replicates the
            enp4s0f1.useDHCP = true;						# default behaviour.
            wlp3s0.useDHCP = true;
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
        enable = true;				# Enable the X11 windowing system
        layout = "us";				# Configure X11 keymap layout
        # libinput.enable = true;		# Enable touchpad support (if necessary)

        displayManager = {
            sddm.enable = true;			# Enable SDDM display manager
            sddm.autoNumlock = true;		# Enable Numlock on startup
        };

        desktopManager.plasma5.enable = true;	# Enable the KDE Plasma 5 desktop environment
    };

  # Enable CUPS to print documents.
    services.printing.enable = true;

  # Enable sound.
    sound.enable = true;
    hardware.pulseaudio.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

    system.stateVersion = "21.11"; # Did you read the comment?

}

