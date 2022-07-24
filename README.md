# nixos-dotfiles
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
$ git clone https://github.com/HunterThueson/nixos-dotfiles.git dotfiles-dir
```

<h4>6. Copy into /etc/nixos</h4>

```
# cp -r dotfiles-dir/* /etc/nixos/*
```

<h4>7. Generate hardware scan</h4>

```
# nixos-generate-config
```
Congratulations! You have reached the end of the installation instructions, at least
for now. I plan on expanding these instructions once I get acquainted with Nix Flakes,
Home Manager, etc. and write myself an automated system builder, but for now this should
do nicely. **Don't forget to run `passwd` for each user!**

Note: as of 2022.07.21, there may be a few additional steps that need to be followed
post-install to make sure the system is up and running properly. I am currently
compiling a list of exactly which steps still need to be automated, which will be
available soon.

Also, I probably don't have to say this, but just in case: this repository is simply
a publicly-available copy of my personal dotfiles. As such, I make no guarantees that
this will work on your system, or that using these files in any way (including following
the installation instructions here in the README) will not completely and utterly
destroy everything on your computer. Basically, don't be surprised if you run into
issues, don't expect any help from me if you do, and don't hold me responsible for any
data loss or damage you do to your computer. *(I'll pick out a more official license with
terms along these lines in the future, but for now, this paragraph should do nicely.)*
