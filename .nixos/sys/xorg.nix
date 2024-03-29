# ./sys/xorg.nix

############################
#  X Server Configuration  #
############################

# This file configures a two-monitor mixed-DPI setup with a Dell S2417DG 24" 1440p 144hz monitor on the right side
# and a Gigabyte M28U 28" 4k 144hz monitor on the left. They are aligned based on the middle of each screen (vertically)
# and they are each connected to a DisplayPort connector on an EVGA GeForce RTX 3090 FTW3 graphics card. The 1440p
# monitor is rotated 90 degrees, such that the top edge of the screen is touching the right edge of the 4k monitor.
# The image output is therefore rotated 90 degrees counter-clockwise to compensate.

#####################
#  Important Notes  #
#####################

# In order to prevent KDE Plasma from resetting `xrandr` settings when logging in, go to
# System Settings -> Startup and Shutdown -> Background Services and disable 'Kscreen 2'. I'll eventually try to
# figure out how to automate that setting, but since I'm planning to switch to a different WM soon anyway it's not
# a very high priority at the moment.

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
            Identifier    "Monitor-1440p"
            VendorName    "Dell Ultrasharp"
            ModelName     "S2417DG"
            Modeline      "2560x1440_144.00"  808.75  2560 2792 3072 3584  1440 1443 1448 1568 -hsync +vsync
            Option        "DPMS" "true"
            Option        "PreferredMode" "2560x1440_144.00"
            Option        "Position" "3840 0"
       '';

    # Screen configuration
        screenSection = ''
            Option        "MetaModes" "DPY-EDID-809ecabe-c3d2-29e6-1a2c-7adf94323603: 3840x2160_144 @3840x2160 +0+517 { ViewPortIn=3840x2160, ViewPortOut=3840x2160+0+0, ForceCompositionPipeline=On, AllowGSYNCCompatible=On }, DPY-EDID-bf730b70-03cb-6513-f349-55323aee38c4: 2560x1440_144 +3840+0 { Rotation=right, ViewPortIn=1796x3193, ViewPortOut=1440x2560+0+0, ForceCompositionPipeline=On, AllowGSYNC=On, }"
            Option        "SLI" "off"
            Option        "MultiGPU" "off"
            Option        "nvidiaXineramaInfo" "true"
            SubSection    "Display"
                Depth      24
                Virtual    5636 3193
            EndSubSection
        '';

        displayManager = {
            sddm = {
                enable = true;
                enableHidpi = true;
                autoNumlock = true;
            };
            xserverArgs = [ "-dpi 154" ];
        };
    };
}

#####################
#  My Monitor Info  #
#####################

# Gigabyte M28U 4k monitor info:
    # 631.928 mm x 359.78 mm, 727.169 mm diagonal
    # 3840 x 2160
    # DPI = 153.9

    # Identifiers:
    #   DFP-5
    #   DPY-EDID-809ecabe-c3d2-29e6-1a2c-7adf94323603
    #   DPY-5
    #   DP-4
    #   Connector-0

# Dell Ultrasharp S2417DG 1440p monitor info:
    # 526.85 mm x 296.35 mm (when in landscape mode), 604.7 mm diagonal
    # 2560 x 1440
    # DPI = 123.38

    # Identifiers:
    #   DFP-3
    #   DPY-EDID-bf730b70-03cb-6513-f349-55323aee38c4
    #   DPY-3
    #   DP-2
    #   Connector-1

###############################
#  Fixing DPI/Scaling Issues  #
###############################

# Target DPI: 153.9
# 123.38 * 1.24736586156589398606 = 153.9
# Scaling factor (f) = 1.24736586156589398606
# 2560 * f = ~3193.26 rounded to 3193
# 1440 * f = ~1796.21 rounded to 1796
# New X Screen Virtual Resolution: 5636x3193
# 3193 - 2160 = 1033 -1 = 1032 / 2 = 516
# New vertical offset for 4k monitor: +0+517

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

