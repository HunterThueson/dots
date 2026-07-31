# environment/services/syncthing.nix

#-------------#
#  Syncthing  #
#-------------#

# Continuous file sync between hosts, driven by userSettings.sync flags.
# nixos: sops-provisioned device identity + firewall, when any user syncs
# home:  per-user syncthing service, peer devices, and synced folders
#
# Device identities are pre-generated so both machines deploy fully
# declaratively: the private cert/key pairs live in the per-host sops files
# (system/security/secrets/<host>.yaml) and the device IDs below are public
# key fingerprints, safe to commit. [1]

let
  devices = {
    hephaestus = "Y6EA347-3W4AXYH-XFS3VXX-XATU6NH-HQY3SGB-IDNNI6C-3Y62PPU-OVCOHQ7";
    artemis    = "6JKTH3M-X5IFOCW-QDDHWUA-JOJHOL2-UMU7553-VI3B6H7-BNBOAQW-LBRR5AL";
  };

  syncsAnything = u: u.sync.osrs;
in
{
  nixos = { config, lib, flakeRoot, ... }:
  let
    hostName  = config.networking.hostName;
    syncUsers = lib.filterAttrs (_: u: syncsAnything u) config.userSettings;
  in {
    config = lib.mkIf (devices ? ${hostName} && syncUsers != {}) {

      # One pre-generated identity per syncing user, from this host's sops file [2]
      sops.secrets = lib.concatMapAttrs (username: _: {
        "${username}-syncthing-cert" = {
          sopsFile = "${flakeRoot}/system/security/secrets/${hostName}.yaml";
          owner    = username;
        };
        "${username}-syncthing-key" = {
          sopsFile = "${flakeRoot}/system/security/secrets/${hostName}.yaml";
          owner    = username;
        };
      }) syncUsers;

      # Syncthing defaults: transfers + local discovery broadcasts
      networking.firewall = {
        allowedTCPPorts = [ 22000 ];
        allowedUDPPorts = [ 22000 21027 ];
      };
    };
  };

  home = { config, lib, hostName, ... }:
  let
    user     = config.userSettings;
    username = config.home.username;
    peers    = lib.filterAttrs (h: _: h != hostName) devices;
    runelite = "${config.home.homeDirectory}/.local/share/bolt-launcher/.runelite";
  in {
    config = lib.mkIf (devices ? ${hostName} && syncsAnything user) {

      services.syncthing = {
        enable = true;
        cert   = "/run/secrets/${username}-syncthing-cert";                     # provisioned by nixos-rebuild [2]
        key    = "/run/secrets/${username}-syncthing-key";

        settings = {
          devices = lib.mapAttrs (_: id: { inherit id; }) peers;

          folders = lib.mkIf user.sync.osrs {
            osrs-runelite = {
              id      = "osrs-runelite";
              label   = "OSRS RuneLite";
              path    = runelite;                                               # Bolt launcher's RuneLite home [3]
              devices = lib.attrNames peers;
            };
          };
        };
      };

      # Keep machine-local churn out of the OSRS sync [4]
      home.file.".local/share/bolt-launcher/.runelite/.stignore" = lib.mkIf user.sync.osrs {
        text = ''
          /cache
          /jagexcache
          /logs
          /repository2
          /jagex_cl_oldschool_LIVE.dat
          /random.dat
        '';
      };
    };
  };
}

#-------------#
#  Footnotes  #
#-------------#

# 1: To add a host to the mesh: `syncthing generate --home=<tmpdir>`, put the
#    resulting cert.pem/key.pem into system/security/secrets/<host>.yaml as
#    <user>-syncthing-cert / <user>-syncthing-key (sops -e), and add the
#    printed device ID to `devices` above. Ports are syncthing's defaults, so
#    only one syncing user per host works as-is; a second would need distinct
#    listen/GUI ports.

# 2: The /run/secrets/* paths exist only after a `nixos-rebuild switch` on
#    that host — a standalone `home-manager switch` config still evaluates,
#    but the service can't start until the system path has provisioned the
#    secrets once.

# 3: Bolt sandboxes RuneLite with HOME=~/.local/share/bolt-launcher, so the
#    live config is its inner .runelite; the top-level ~/.runelite is a stale
#    remnant of running RuneLite directly (untouched since Feb 2026). Bolt's
#    own creds/settings.json are not synced: Jagex session tokens rotate, and
#    sharing them between machines risks logging both out.

# 4: The ignored entries are regenerated game/plugin caches and logs; what
#    syncs is what carries state worth keeping (profiles2 = all RuneLite
#    settings, plugin data dirs, screenshots). Graphics settings live in
#    profiles2 too, so they currently sync between machines — if the laptop
#    ever needs weaker GPU settings, switch it to its own RuneLite profile
#    via the in-client profile panel rather than unsyncing profiles2.

# EOF
