# ~/.config/nixos/xorg.nix

############################
## X Server Configuration ##
############################

# This file configures a two-monitor mixed-DPI setup with a Dell S2417DG 24" 1440p 144hz monitor on the left side
# and a Gigabyte M28U 28" 4k 144hz monitor on the right. They are aligned based on the middle of each screen (vertically)
# and they are each connected to a DisplayPort connector on an EVGA GeForce RTX 3090 FTW3 graphics card.

{ config, pkgs, ... }:

{
    services.xserver = {

    # 4K monitor configuration
        monitorSection = ''
            VendorName    "Gigabyte"
            ModelName     "M28U"
            Modeline      "3840x2160_144.00"  1829.25  3840 4200 4624 5408  2160 2163 2168 2350 -hsync +vsync
            Option        "Primary" "true"
            Option        "DPMS" "true"
            Option        "PreferredMode" "3840x2160_144.00"
            Option        "Position" "2560 0"
        '';

        screenSection = ''
            Option        "MetaModes" "DPY-EDID-809ecabe-c3d2-29e6-1a2c-7adf94323603: 3840x2160_144 @3840x2160 +2560+0 {ViewPortIn=3840x2160, ViewPortOut=3840x2160+0+0, ForceCompositionPipeline=On, AllowGSYNCCompatible=On}, DPY-EDID-bf730b70-03cb-6513-f349-55323aee38c4: 2560x1440_144 @2560x1440 +0+360 {ViewPortIn=2560x1440, ViewPortOut=2560x1440+0+0, ForceCompositionPipeline=On, AllowGSYNC=On}"
            Option        "SLI" "off"
            Option        "MultiGPU" "off"
            Option        "nvidiaXineramaInfo" "false"
            SubSection    "Display"
                Depth      24
                Virtual    6400 2160
            EndSubSection
        '';

    # Define 2K monitor
        extraConfig = ''
            Section "Monitor"
                Identifier    "DP-2"
                VendorName    "Dell Ultrasharp"
                ModelName     "S2417DG"
                Modeline      "2560x1440_144.00"  808.75  2560 2792 3072 3584  1440 1443 1448 1568 -hsync +vsync
                Option        "DPMS" "true"
                Option        "PreferredMode" "2560x1440_144.00"
                Option        "Position" "0 360"
            EndSection
        '';
    };
}

# Gigabyte M28U 4k monitor EDID:
    # DPY-EDID-809ecabe-c3d2-29e6-1a2c-7adf94323603

# Dell Ultrasharp S2417DG 1440p monitor EDID:
    # DPY-EDID-bf730b70-03cb-6513-f349-55323aee38c4
