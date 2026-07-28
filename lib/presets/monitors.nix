# lib/presets/monitors.nix

#------------#
#  Monitors  #
#------------#

# Monitor presets define individual monitors.
# Layout presets define complete multi-monitor arrangements including xorg config.

{ lib, ... }:

{
  #---------------------#
  #  Individual Monitors #
  #---------------------#

  gigabyte = {
    m28u = {
      name = "Gigabyte M28U";
      resolution  = lib.mkDefault "3840x2160@144";
      orientation = lib.mkDefault "landscape";
      placement   = lib.mkDefault "primary";
    };
  };

  dell = {
    s2417dg = {
      name = "Dell S2417DG";
      resolution = lib.mkDefault "2560x1440@144";
      orientation = lib.mkDefault "landscape";
      placement = lib.mkDefault "primary";
    };
  };

  lenovoThinkPad = {
    "built-in" = {
      name = "Lenovo ThinkPad X1 Carbon Gen 12 built-in screen";
      resolution = lib.mkDefault "2880x1800@120";
      orientation = lib.mkDefault "landscape";
      placement = lib.mkDefault "primary";
    };
  };

  #-------------------#
  #  Layout Presets   #
  #-------------------#

  # Complete monitor arrangements — portable across hosts.
  # Each layout includes the monitors list and xorg-specific configuration.
  #
  # Both layouts drive the same two panels over DisplayPort on the RTX 3090:
  #   Gigabyte M28U → DP-4 (NVIDIA DFP-5), 4K primary, landscape, left
  #   Dell S2417DG  → DP-2 (NVIDIA DFP-3), 1440p, right                    [1]
  # They differ only in the Dell's orientation (landscape vs. portrait).
  #
  # DPI matched to the 4K panel; the Dell is scaled via ViewPort to compensate:
  #   Target DPI: 153.9 (native DPI of the Gigabyte M28U)
  #   Dell scaling factor: 153.9 / 123.42 = 1.24696
  #   Dell scaled dimensions: 2560 * 1.247 = 3192, 1440 * 1.247 = 1796

  layouts = {

    # Gigabyte M28U (4K primary, landscape, left) + Dell S2417DG (1440p, landscape, right)
    #   Virtual screen: x = 3840 + 3192 = 7032, y = 2160
    #   Dell vertical offset (centered): (2160 - 1796) / 2 = 182
    "m28u-landscape--s2417dg-landscape-right" = {
      alignment = "center";
      monitors = [
        {
          name = "Gigabyte M28U";
          resolution = "3840x2160@144";
          orientation = "landscape";
          placement = "primary";
        }
        {
          name = "Dell S2417DG";
          resolution = "2560x1440@144";
          orientation = "landscape";
          placement = {
            position = "right-of";
            relativeTo = "primary";
          };
        }
      ];
      xorg = {
        dpi = 154;
        virtualScreen = { x = 7032; y = 2160; };
        screenSection = ''
          Option    "MetaModes" "DP-4: 3840x2160_144 +0+0 { ForceCompositionPipeline=On, AllowGSYNCCompatible=On }, DP-2: 2560x1440_144 +3840+182 { ViewPortIn=3192x1796, ViewPortOut=2560x1440, ForceCompositionPipeline=On }"
        '';
        xrandrHeads = [
          {
            output = "DP-4";
            primary = true;
            monitorConfig = ''
              Modeline "3840x2160_144.00"  1833.14  3840 4200 4632 5424  2160 2161 2164 2347  -HSync +Vsync
              Option "DPMS" "true"
              Option "PreferredMode" "3840x2160_144.00"
              Option "Position" "0 0"
            '';
          }
          {
            output = "DP-2";
            primary = false;
            monitorConfig = ''
              Option "DPMS" "true"
              Option "PreferredMode" "2560x1440_144.00"
              Option "Position" "3840 182"
            '';
          }
        ];
      };
    };

    # Gigabyte M28U (4K primary, landscape, left) + Dell S2417DG (1440p, portrait, right)
    #   Dell rotated left (CCW); scaled dimensions swap to 1796 x 3192
    #   Virtual screen: x = 3840 + 1796 = 5636, y = 3192 (taller of the two)
    #   Dell top-aligned with the primary: +3840+0
    "m28u-landscape--s2417dg-portrait-right" = {
      alignment = "center";
      monitors = [
        {
          name = "Gigabyte M28U";
          resolution = "3840x2160@144";
          orientation = "landscape";
          placement = "primary";
        }
        {
          name = "Dell S2417DG";
          resolution = "2560x1440@144";
          orientation = "portrait";
          placement = {
            position = "right-of";
            relativeTo = "primary";
          };
        }
      ];
      xorg = {
        dpi = 154;
        virtualScreen = { x = 5636; y = 3192; };
        screenSection = ''
          Option    "MetaModes" "DP-4: 3840x2160_144 +0+0 { ForceCompositionPipeline=On, AllowGSYNCCompatible=On }, DP-2: 2560x1440_144 +3840+0 { Rotation=left, ViewPortIn=1796x3192, ViewPortOut=2560x1440, ForceCompositionPipeline=On }"
        '';
        xrandrHeads = [
          {
            output = "DP-4";
            primary = true;
            monitorConfig = ''
              Modeline "3840x2160_144.00"  1833.14  3840 4200 4632 5424  2160 2161 2164 2347  -HSync +Vsync
              Option "DPMS" "true"
              Option "PreferredMode" "3840x2160_144.00"
              Option "Position" "0 0"
            '';
          }
          {
            output = "DP-2";
            primary = false;
            monitorConfig = ''
              Option "DPMS" "true"
              Option "PreferredMode" "2560x1440_144.00"
              Option "Position" "3840 0"
            '';
          }
        ];
      };
    };

  };
}


#-------------#
#  Footnotes  #
#-------------#

# 1: These are the NVIDIA X driver's connector names, not the kernel DRM names
#    KWin/Wayland uses (there the panels are DP-5 = M28U, DP-4 = Dell). This
#    boot's X server reported the Dell as DFP-3 and the M28U as DFP-5; the
#    known-good config's "DP-4" resolves to DFP-5 (the M28U), so by the same
#    DFP→DP mapping the Dell (DFP-3) is DP-2. X11 has not yet started with the
#    Dell on DisplayPort to confirm that type-name directly — if an X11 session
#    ever leaves the Dell blank, check `nvidia-settings -q dpys` or the Xorg
#    log's "display device" lines and correct DP-2 here. (Daily use is Wayland,
#    which is unaffected by this file.)
