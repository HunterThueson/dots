# environment/desktop/plasma.nix

#----------------------------#
#  KDE Plasma Configuration  #
#----------------------------#

# The user perceives the full desktop environment.
# Enabled when the host's merged session list (lib/sessions.nix) includes
# "plasma" or "plasmax11".

{
  nixos = { config, pkgs, lib, ... }:
  let
    sessions = import ../../lib/sessions.nix;
    enabled = sessions.forHost {
      inherit (config) hostSettings;
      users = lib.attrValues config.userSettings;
    };
    anyWantsPlasma = lib.elem "plasma" enabled || lib.elem "plasmax11" enabled;
  in {
    config = lib.mkIf anyWantsPlasma {
      services.desktopManager.plasma6.enable = true;
      services.desktopManager.plasma6.enableQt5Integration = true;

      environment.systemPackages = with pkgs; [
        wlr-protocols
        kdePackages.plasma-wayland-protocols
        kdePackages.wayland-protocols
        cosmic-protocols
      ];
    };
  };

  home = { config, lib, ... }:
  let
    userSessions = config.userSettings.desktop.environments;
    wantsPlasma = lib.elem "plasma" userSessions || lib.elem "plasmax11" userSessions;
  in {
    config = lib.mkIf wantsPlasma {
      # Per-user Plasma config (themes, panel layout, etc.)
    };
  };
}
