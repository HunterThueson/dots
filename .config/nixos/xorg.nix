# ~/.config/nixos/xorg.nix

############################
## X Server Configuration ##
############################

# This file configures a two-monitor mixed-DPI setup with a Dell S2417DG 24" 1440p 144hz monitor on the right side
# and a Gigabyte M28U 28" 4k 144hz monitor on the left. They are aligned based on the middle of each screen (vertically)
# and they are each connected to a DisplayPort connector on an EVGA GeForce RTX 3090 FTW3 graphics card. The 1440p
# monitor is rotated 90 degrees, such that the top edge of the screen is touching the right edge of the 4k monitor.
# The image output is therefore rotated 90 degrees counter-clockwise.

#####################
#  Important Notes  #
#####################

# The below configuration doesn't work properly.
# Worse, I've just realized that this is the wrong way to approach xserver configuration. Instead of trying to add
# everything to the first monitor section via `services.xserver.monitorSection`, I should be using `services.xserver...
# `.xrandrHeads`, `.resolutions`, etc.
# You know, the Nix way.
# It's possible I might even be better off replacing `services.xserver.config` entirely. It's normally generated via
# a combination of all the other `services.xserver.*` options, but I should be able to override it somehow in order to
# use my own `xorg.conf` instead. That would probably be better for portability anyways. The NixOS options manual
# mentions the `lib.mkAfter` option, so that'll be my starting point when I continue my Xorg adventures at a later date.

# I should also look into setting the `video=` and/or `vga=` kernel parameters. I just barely scratched the surface of
# my research into that approach, but it sounds like I would be able to set the resolution(s) of the bootloader and
# the Linux console/TTY instead of just the X server. Requires further research.

# Final note: I should migrate the Nvidia driver settings, keyboard layout, and all other sub-options of
# `services.xserver` that are currently in my `configuration.nix` file into this file instead, just to keep all the
# X11-related options in one place. No sense having them scattered all over the place.

# For now, though, I'm dead tired. I've been working on this for hours. It's time for bed.

{ config, pkgs, ... }:

{
    services.xserver = {

    # Enable verbose X logs
        verbose = 7;

    # When enabled, this option disallows the use of Ctrl+Alt+F(n) sequences to switch to virtual terminals
        serverFlagsSection = ''
            Option "DontVTSwitch" "off"
        '';

    # Monitor configuration
        monitorSection = ''
            VendorName    "Gigabyte"
            ModelName     "M28U"
            Modeline      "3840x2160_144.00"  1829.25  3840 4200 4624 5408  2160 2163 2168 2350 -hsync +vsync
            Option        "Primary" "true"
            Option        "DPMS" "true"
            Option        "PreferredMode" "3840x2160_144.00"
            Option        "Position" "0 200"
        EndSection

        Section "Monitor"
            Identifier    "DP-2"
            VendorName    "Dell Ultrasharp"
            ModelName     "S2417DG"
            Modeline      "2560x1440_144.00"  808.75  2560 2792 3072 3584  1440 1443 1448 1568 -hsync +vsync
            Option        "DPMS" "true"
            Option        "PreferredMode" "2560x1440_144.00"
            Option        "Position" "3840 0"
       '';

    # Screen configuration
        screenSection = ''
            Option        "MetaModes" "DPY-EDID-809ecabe-c3d2-29e6-1a2c-7adf94323603: 3840x2160_144 @3840x2160 +0+200 { ViewPortIn=3840x2160, ViewPortOut=3840x2160+0+0, ForceCompositionPipeline=On, AllowGSYNCCompatible=On }, DPY-EDID-bf730b70-03cb-6513-f349-55323aee38c4: 2560x1440_144 +3840+0 { Rotation=right, ViewPortIn=1440x2560, ViewPortOut=1440x2560+0+0, ForceCompositionPipeline=On, AllowGSYNC=On, }"
            Option        "SLI" "off"
            Option        "MultiGPU" "off"
            Option        "nvidiaXineramaInfo" "true"
            Option        "ConnectedMonitor" "DFP-1, DFP-3"
            SubSection    "Display"
                Depth      24
                Virtual    5280 2560
            EndSubSection
        '';

    };
}

#####################
#  My Monitor Info  #
#####################

# Gigabyte M28U 4k monitor info:
    # DFP-3
    # DPY-EDID-809ecabe-c3d2-29e6-1a2c-7adf94323603
    # DPY-3
    # DP-2
    # Connector-1

# Dell Ultrasharp S2417DG 1440p monitor info:
    # DFP-1
    # DPY-EDID-bf730b70-03cb-6513-f349-55323aee38c4
    # DPY-1
    # DP-0
    # Connector-2

###################
#  Tips & Tricks  #
###################

# run `nvidia-settings -q dpys` to get output like the following:
    #
    # 7 Display Devices on the-glass-tower:0
    # 
    #     [0] the-glass-tower:0[dpy:0] (HDMI-0)
    # 
    #       Has the following names:
    #         DFP
    #         DFP-0
    #         DPY-0
    #         HDMI-0
    #         Connector-3
    # 
    #     [1] the-glass-tower:0[dpy:1] (DP-0) (connected, enabled)
    # 
    #       Has the following names:
    #         DFP
    #         DFP-1
    #         DPY-EDID-bf730b70-03cb-6513-f349-55323aee38c4
    #         DPY-1
    #         DP-0
    #         Connector-2
    # 
    #     [2] the-glass-tower:0[dpy:2] (DP-1)
    # 
    #       Has the following names:
    #         DFP
    #         DFP-2
    #         DPY-2
    #         DP-1
    #         Connector-2
    # 
    #     [3] the-glass-tower:0[dpy:3] (DP-2) (connected, enabled)
    # 
    #       Has the following names:
    #         DFP
    #         DFP-3
    #         DPY-EDID-809ecabe-c3d2-29e6-1a2c-7adf94323603
    #         DPY-3
    #         DP-2
    #         Connector-1
# Look for the section(s) that say(s) "(connected, enabled)"

# Alternatively, running `xrandr` without any options will give
# output that looks like this:
    # Screen 0: minimum 8 x 8, current 5280 x 2560, maximum 32767 x 32767
    # HDMI-0 disconnected (normal left inverted right x axis y axis)
    # DP-0 connected 1440x2560+3840+0 right (normal left inverted right x axis y axis) 527mm x 296mm
    #    2560x1440     59.95 + 144.00*  120.00    99.95    84.98    23.97  
    #    1024x768      60.00  
    #    800x600       60.32  
    #    640x480       59.94  
    # DP-1 disconnected (normal left inverted right x axis y axis)
    # DP-2 connected primary 3840x2160+0+0 (normal left inverted right x axis y axis) 630mm x 360mm
    #    3840x2160     60.00 + 144.00*  120.00   119.88    59.94    23.98  
    #    2560x1440    143.86   119.88    59.94  
    #    1920x1080    143.85   119.88    60.00    59.94    23.98  
    #    1680x1050     59.95  
    #    1440x900      59.89  
    #    1280x1024     60.02  
    #    1280x720     119.88    59.94  
    #    1024x768      75.03    60.00  
    #    800x600       75.00    60.32  
    #    720x480       59.94  
    #    640x480       75.00    59.94  
    # DP-3 disconnected (normal left inverted right x axis y axis)
    # DP-4 disconnected (normal left inverted right x axis y axis)
    # DP-5 disconnected (normal left inverted right x axis y axis)
# This method won't give you the EDID or other types of names, but the advantage of doing it this way
# is that `xrandr` will give you modelines, which are located the line beneath where it says
# (for example) "DP-0 Connected..." for each respective monitor.

# Modeline calculation can be simplified with the `cvt` command. For instance, `cvt 1440 2560` gives:
    # # 1440x2560 59.98 Hz (CVT) hsync: 159.00 kHz; pclk: 318.00 MHz
    # Modeline "1440x2560_60.00"  318.00  1440 1568 1720 2000  2560 2563 2573 2651 -hsync +vsync

