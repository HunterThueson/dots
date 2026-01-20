# ./system/display/sddm.nix

# SDDM Configuration

{ config, pkgs, inputs, ... }:

{
    services.displayManager = {
        sddm = {
            enable = true;
            enableHidpi = true;
            autoNumlock = true;
        };
    };
}
