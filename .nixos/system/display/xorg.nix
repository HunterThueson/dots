# ./system/display/xorg.nix

# XOrg/XServer configuration

###############################
#  Fixing DPI/Scaling Issues  #
###############################

# the following calculations are for a landscape-landscape setup
# Target DPI: 153.9
# to find scaling factor: divide target dpi by current dpi
#   153.9 / 123.42 = 1.24696
# to find target virtual resolution: multiply current resolution x and y by scaling factor
#   2560 * 1.24696 = 3192.2176 (rounded down)
#   1440 * 1.24696 = 1795.6224 (rounded up)
# Virtual resolution of: 7032 x 2160
#   x = 3840 + 3192 = 7032 (since we are having the monitors side by side)
#   y = 2160 (since one monitor is already bigger than the other)
# Now we figure out the vertical offset for monitor 2:
#   2160 - 1796 = 364
#   364 / 2 = 182

{ config, pkgs, inputs, ... }:
{
  services.xserver = {
    enable = true;
    verbose = 7;                                            # increase verbosity of X logs

    # Monitor configuration
    displayManager.xserverArgs = [ "-dpi 154" ];            # set screen dpi
    virtualScreen = {
      x = 7032;                                             # strange screen size is due to the way I'm adjusting dpi for different resolution
      y = 2160;                                             # monitors in my current setup
    };
    screenSection = ''
      Option    "MetaModes" "DP-4: 3840x2160_144 +0+0 { ForceCompositionPipeline=On, AllowGSYNCCompatible=On }, DP-2: 2560x1440_144 +3840+182 { ViewPortIn=3192x1796, ViewPortOut=2560x1440, ForceCompositionPipeline=On, AllowGSYNC=On }"
    '';
    xrandrHeads = [
      # Gigabyte M28U @ 3840x2160
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
      # Dell Ultrasharp S2417DG @ 2560x1440
      {
        output = "DP-2";
        monitorConfig = ''
          Modeline "2560x1440_144.00"  807.69  2560 2784 3072 3584  1440 1441 1444 1565  -HSync +Vsync
          Option "DPMS" "true"
          Option "PreferredMode" "2560x1440_144.00"
          Option "Position" "3840 182"
        '';
      }
    ];
  };
}

