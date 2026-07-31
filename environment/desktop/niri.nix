# environment/desktop/niri.nix

#-------------------------------------#
#  Niri Scrollable-Tiling Compositor  #
#-------------------------------------#

# Enables the niri session system-wide when the host's merged session list
# (lib/sessions.nix) includes "niri". Per-user niri config (keybinds, layout)
# doesn't exist yet, so this file exports only `nixos`; a `home` export can
# sit alongside it once that work starts.

{
  nixos = { config, lib, ... }:
  let
    sessions = import ../../lib/sessions.nix;
    enabled = sessions.forHost {
      inherit (config) hostSettings;
      users = lib.attrValues config.userSettings;
    };
  in {
    config = lib.mkIf (lib.elem "niri" enabled) {
      programs.niri.enable = true;
    };
  };
}
