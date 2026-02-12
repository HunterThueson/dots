# ./system/boot/loader.nix

########################
#  Bootloader Options  #
########################

{ config, pkgs, inputs, ... }:

{

  #  Enable whichever bootloader you want to use here
  boot.loader.grub.enable = true;
  boot.loader.systemd-boot.enable = false;

  ##########################
  #  General boot options  #
  ##########################

  boot = {
    kernelPackages = pkgs.linuxPackages;                                    # Use the default, stable Linux kernel
    loader = {
      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = true;
      };
    };
  };

  ########
  # Grub #
  ########

  boot.loader.grub = {                                                      # Use the GRUB 2 boot loader
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    configurationLimit = 25;                                                # Limit the number of GRUB menu entries

    # Enable Memtest86 (unfree) EFI-compatible system diagnostics utility
    extraFiles = {
      "memtest86.efi" = "${pkgs.memtest86-efi}/BOOTX64.efi";
    };
    extraEntries = ''
      menuentry "Memtest86" {
        chainloader @bootRoot@/memtest86.efi
      }
    '';
  };

  ################
  # systemd-boot #
  ################

  boot.loader.systemd-boot = {                                              # Use the systemd-boot boot loader
    memtest86.enable = true;                                                # Enable Memtest86
    configurationLimit = 25;                                                # Limit the number of systemd-boot menu entries
    editor = false;                                                         # Disable editing kernel cmd line before boot -- security risk (root access)
  };

}
