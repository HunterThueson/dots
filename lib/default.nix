# lib/default.nix

#-----------------------#
#  Flake Library Index  #
#-----------------------#

# Single entry point for all lib utilities.
# Usage in flake.nix:
#   inherit (import ./lib { inherit inputs lib flakeRoot; })
#     mkHosts mkHomes keyboardPresets monitorPresets gpuPresets;

{ inputs, lib, flakeRoot }:

{
  mkHosts         = import ./mkHosts.nix { inherit inputs lib flakeRoot; };
  mkHomes         = import ./mkHomes.nix { inherit inputs lib flakeRoot; };
  sessions        = import ./sessions.nix;
  keyboardPresets = import ./presets/keyboards.nix;
  monitorPresets  = import ./presets/monitors.nix { inherit lib; };
  gpuPresets      = import ./presets/gpus.nix;
}
