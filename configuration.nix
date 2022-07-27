# /etc/nixos/configuration.nix

{ config, pkgs, ... }:

{
    imports = 
        [
            ./hardware-configuration.nix					# include the results of the hardware scan
            ./pkg-config.nix							# separate file for package management
            ./user-config.nix							# separate file for user definitions
        ];

    boot = {

        kernelParams =
            [
                "acpi_rev_override"
                "mem_sleep_default=deep"
                "intel_iommu=igfx_off"
                "nvidia-drm.modeset=1"
            ];

        kernelPackages = pkgs.linuxPackages_latest;				# Use the latest LTS Linux kernel
        extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

        loader = {
            grub = {								# Use the GRUB 2 boot loader
                enable = true;
                device = "nodev";
                efiSupport = true;
                version = 2;
                useOSProber = true;
            };
            efi = {
                canTouchEfiVariables = true;
                efiSysMountPoint = "/boot/efi";
            };
        };
    };

    networking.networkmanager.enable = true;					# Enables networking via NetworkManager
    networking.hostName = "nixos"; 						# (note: NetworkManager & wpa_supplicant are not compatible)

    time = {
        timeZone = "America/Denver";						# Set your time zone.
        hardwareClockInLocalTime = true;					# Keep the hardware clock in local time instead of UTC
    };										# for compatibility with Windows Dual Boot

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp4s0f1.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable proprietary NVIDIA drivers
    environment.systemPackages = with pkgs; [
        pciutils
        file
        
        gnumake
        gcc
        
        cudatoolkit
    ]; 
    nixpkgs.config.allowUnfree = true;
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

  # Enable and configure lightdm
  #  services.xserver.displayManager.lightdm = {
  #   enable = true;
  #  greeters.gtk.clock-format = "%F"; # Equivalent to "%Y-%m-%d"

    # Force users to enter their username as well as password at login
    # extraSeatDefaults = ''
       #  greeter-show-manual-login=true
        #greeter-hide-users = true
        #allow-guest = false
      #'';

  #};

  # Enable SDDM
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.displayManager.sddm.autoNumlock = true;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.desktopManager.plasma5.enable = true;
  
  # Configure keymap in X11
  services.xserver.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktop managers).
  services.xserver.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

