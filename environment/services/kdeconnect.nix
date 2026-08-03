# environment/services/kdeconnect.nix

#---------------#
#  KDE Connect  #
#---------------#

# Phone <-> desktop integration (notifications, clipboard, file transfer,
# media control, remote input), driven by userSettings.kdeconnect.
# nixos: firewall holes for the KDE Connect protocol when any user runs it
# home:  per-user daemon + tray indicator, started with every graphical
#        session and gated per-session at unit start [1]

let
  runsAnywhere = u: u.kdeconnect.enable || u.kdeconnect.exceptSessions != [];
in
{
  nixos = { config, lib, ... }:
  let
    connectUsers = lib.filterAttrs (_: u: runsAnywhere u) config.userSettings;
  in {
    config = lib.mkIf (connectUsers != {}) {

      # KDE Connect's fixed protocol range: UDP discovery + per-device links [2]
      networking.firewall = {
        allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
        allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
      };
    };
  };

  home = { config, lib, pkgs, hostName, ... }:
  let
    user    = config.userSettings;
    plasmas = [ "plasma" "plasmax11" ];

    # Session gate for ExecCondition: exit 0 starts the unit, exit 1 skips it
    # cleanly. Detects the live session from the unit's environment. [3]
    gate = { sessions, whenMatched, otherwise }:
      pkgs.writeShellScript "kdeconnect-session-gate" ''
        case "''${XDG_CURRENT_DESKTOP:-}" in
          *Hyprland*) session="hyprland" ;;
          *niri*)     session="niri" ;;
          *KDE*)      if [ "''${XDG_SESSION_TYPE:-wayland}" = "x11" ]
                      then session="plasmax11"
                      else session="plasma"
                      fi ;;
          *)          session="unknown" ;;
        esac
        case " ${toString sessions} " in
          *" $session "*) exit ${toString whenMatched} ;;
        esac
        exit ${toString otherwise}
      '';
    skipIn = list: gate { sessions = list; whenMatched = 1; otherwise = 0; };
    onlyIn = list: gate { sessions = list; whenMatched = 0; otherwise = 1; };

    # exceptSessions inverts enable per session; no gate at all when the
    # daemon runs everywhere
    daemonGate =
      if !user.kdeconnect.enable
      then onlyIn user.kdeconnect.exceptSessions
      else if user.kdeconnect.exceptSessions != []
      then skipIn user.kdeconnect.exceptSessions
      else null;

    # The standalone indicator additionally skips Plasma, whose system tray
    # already ships a KDE Connect widget (bundled with the package)
    indicatorSessions = lib.subtractLists plasmas user.kdeconnect.exceptSessions;
    indicatorOn      = user.kdeconnect.enable || indicatorSessions != [];
    indicatorGate =
      if user.kdeconnect.enable
      then skipIn (lib.unique (user.kdeconnect.exceptSessions ++ plasmas))
      else onlyIn indicatorSessions;

    owner = if user.nickname != "" then user.nickname else config.home.username;
  in {
    config = lib.mkIf (runsAnywhere user) {

      services.kdeconnect = {
        enable    = true;
        indicator = indicatorOn;
      };

      systemd.user.services = {
        kdeconnect = lib.mkIf (daemonGate != null) {
          Service.ExecCondition = "${daemonGate}";
        };
        kdeconnect-indicator = lib.mkIf indicatorOn {
          Service.ExecCondition = "${indicatorGate}";
        };
      };

      # The indicator unit requires HM's conventional tray.target, which no
      # other module defines yet; move it out of here if another tray applet
      # appears. (Definition from the HM manual's tray.target FAQ.)
      systemd.user.targets.tray = lib.mkIf indicatorOn {
        Unit = {
          Description = "Home Manager System Tray";
          Requires    = [ "graphical-session-pre.target" ];
        };
      };

      # Shadow the package's XDG autostart entry so the gated systemd unit is
      # the daemon's only starter [4]
      xdg.configFile."autostart/org.kde.kdeconnect.daemon.desktop".text = ''
        [Desktop Entry]
        Hidden=true
      '';

      # Name this desktop "<host> (<nickname>)" so a phone paired to several
      # user@host combos can tell them apart [5]
      home.activation.kdeconnectDeviceName = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        run mkdir -p "$HOME/.config/kdeconnect"
        run ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
          --file "$HOME/.config/kdeconnect/config" \
          --group General --key name "${hostName} (${owner})"
      '';
    };
  };
}

#-------------#
#  Footnotes  #
#-------------#

# 1: The daemon/indicator units are WantedBy graphical-session.target, so they
#    ride along with any session. Which session a login will be isn't knowable
#    at build time (SDDM lets a user pick any installed session, including
#    ones outside their own desktop.environments), so the enable/exceptSessions
#    logic runs at unit start via ExecCondition instead; sessions the gate
#    can't identify follow `enable`. Pairing state itself is imperative
#    (~/.config/kdeconnect/<deviceId>/ certs written at pair time) and
#    survives rebuilds — each user pairs their own phone(s), so per-user
#    phones need no extra config here.

# 2: Same range the upstream NixOS programs.kdeconnect module opens. The
#    firewall is host-level, so it opens if ANY user on the host runs KDE
#    Connect. Concurrent sessions (e.g. hunter + ash logged in at once) run
#    two daemons; the discovery socket is opened with address reuse so they
#    mostly coexist, but if a phone ever sees only one of two logged-in
#    users, that port contention is the place to look.

# 3: Reads XDG_CURRENT_DESKTOP / XDG_SESSION_TYPE from the systemd user
#    environment. All three session families import them at startup: Plasma
#    syncs the full environment, Hyprland via its HM systemd.variables =
#    ["--all"] (environment/desktop/hyprland), niri-session imports the full
#    environment. Plasma Wayland and X11 both report XDG_CURRENT_DESKTOP=KDE
#    and are told apart by XDG_SESSION_TYPE.

# 4: The package ships etc/xdg/autostart/org.kde.kdeconnect.daemon.desktop,
#    honored by both Plasma and Hyprland's enableXdgAutostart — unshadowed, it
#    would start the daemon even in gated-off sessions. Plasma's tray widget
#    can still D-Bus-activate the daemon (share/dbus-1/services) whenever the
#    package is installed, so gating *only* Plasma off is best-effort; a user
#    who truly wants no KDE Connect in Plasma but keeps it elsewhere will
#    still see it wake up there occasionally.

# 5: kdeconnectd's default device name is the bare hostname, which would make
#    hunter@hephaestus and ash@hephaestus indistinguishable on a shared phone.
#    kwriteconfig6 edits only the `name` key in ~/.config/kdeconnect/config,
#    preserving daemon-written state around it; a running daemon shows the new
#    name after its next restart. Renaming never breaks pairings (devices are
#    tracked by certificate, not name). Because this runs on every HM
#    activation, a rename made in the KDE Connect GUI gets reverted at the
#    next switch — change the name here instead.

# EOF
