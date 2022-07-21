# nixos-dotfiles
for backing up, managing, and (potentially) sharing my NixOS configuration files.

<h2>Installation</h2>
<h3>1. Obtain a NixOS .iso file</h3>

- https://nixos.org/download.html (make sure you're getting NixOS, not just Nix)
- You can also create a custom .iso file (which I plan on doing in the future).

<h3>2. "Burn" the .iso file to a USB drive</h3>

To find the USB drive, run `lsblk` without the drive inserted, then insert the drive
and compare the results. If, for instance, /dev/sdc appears on the second `lsblk`
but not the first, then the USB drive is /dev/sdc.

IMPORTANT: MAKE SURE YOU KNOW THE CORRECT DRIVE BEFORE RUNNING THE FOLLOWING COMMAND!

This command will overwrite whatever drive you specify, so make sure there isn't any
important data on the drive before running it.

```
# dd if=input.iso of=/dev/sdc bs=4M conv=fdatasync
```

<h3>3. Boot your computer (or VM) from the USB drive</h3>

You may need to turn off Secure Boot in your BIOS/UEFI options.

<h3>4. Run the installer</h3>

<h3>5. Clone this repository into /etc/nixos</h3>

Note: as of 2022.07.21, there may be a few additional steps that need to be followed
post-install to make sure the system is up and running properly. I am currently
compiling a list of exactly which steps still need to be automated, which will be
available soon.
