# lib/sessions.nix

#--------------------#
#  Desktop Sessions  #
#--------------------#

# Canonical desktop session names plus the availability rules, shared by the
# option schemas (modules/) and the desktop backends (environment/desktop/).

{
  all = [ "hyprland" "niri" "plasma" "plasmax11" ];

  # Sessions to enable host-wide: the host's always-available list plus
  # every session any of its users requests.
  forHost = { hostSettings, users }:
    hostSettings.availableSessions
    ++ builtins.concatMap (u: u.desktop.environments) users;
}
