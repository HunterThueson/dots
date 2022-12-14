# Dotfiles
For backing up, managing, and (potentially) sharing my personal NixOS configuration files.

<h2>Installation</h2>
<h4>1. Obtain a NixOS .iso file</h4>

- https://nixos.org/download.html (make sure you're getting NixOS, not just Nix)
- You can also create a custom .iso file (which I plan on doing in the future).

<h4>2. "Burn" the .iso file to a USB drive</h4>

To find the USB drive, run `lsblk` without the drive inserted, then insert the drive
and compare the results. If, for instance, /dev/sdc appears on the second `lsblk`
but not the first, then the USB drive is /dev/sdc.

IMPORTANT: MAKE SURE YOU KNOW THE CORRECT DRIVE BEFORE RUNNING THE FOLLOWING COMMAND!

This command will overwrite whatever drive you specify, so make sure there isn't any
important data on the drive before running it.

```
# dd if=input.iso of=/dev/sdc bs=4M status=progress conv=fdatasync
```

<h4>3. Boot your computer (or VM) from the USB drive</h4>

You may need to turn off Secure Boot in your BIOS/UEFI options.

<h4>4. Run the installer</h4>
Follow the instructions for the live installer. This step is not too hard to figure
out on your own. If you're using the minimal installer (included with custom ISOs),
chances are good you already know how to do this (and if you don't, well... good luck!)

<h4>5. Clone this repository</h4>

```
# git clone git@github.com/HunterThueson/nixos-dotfiles.git /etc/nixos/
```

<h4>6. Mount your drives and filesystems</h4>

If you have multiple drives that you'd like to mount to your system, you can either

    a) mount them manually after each time you boot, or

    b) mount them before generating the hardware scan, letting NixOS take care of mounting
    the drive(s) for you automatically during startup.

To mount a drive, use the syntax `# mount [/dev/your-drive] [mount-point]`. In my case,
I want to mount a few SATA SSDs at mount points in `/mnt/*`, so my commands look like
this:

```
# mount /dev/sda1 /mnt/sda/
# mount /dev/sdb1 /mnt/sdb/
```
There's no requirement to use `/mnt` or to name your mount points in any specific way,
it's just personal preference.

<h4>7. Generate the hardware scan</h4>

After you've mounted all drives you want auto-mounted during startup, simply run

```
# nixos-generate-config
```

<h4>8. Update your system</h4>

Run the following as `root` (or using `sudo -i`) to update your system:
```
# nixos-rebuild boot --upgrade 		# Note: the 'boot' argument means the system configuration will
                					# only take effect once we reboot the system.
```

Reboot your system.

<h4>9. Celebrate!</h4>
Congratulations! You have reached the end of the installation instructions, at least
for now. I plan on expanding these instructions once I get acquainted with Nix Flakes,
Home Manager, etc. and write myself an automated system builder, but for now this should
do nicely. <b>Don't forget to run `passwd` for each user!</b>

Note: as of 2022.07.21, there may be a few additional steps that need to be followed
post-install to make sure the system is up and running properly. I am currently
compiling a list of exactly which steps still need to be automated, which will be
available soon.

<h2>License</h2>
Nix is released under the [LGPL v2.1](./LICENSE). Most of this project is derivative of Nix, so I'm required
to license it the same way (which I'm more than happy to do as it makes choosing a license much simpler).
