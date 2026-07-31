# lib/mkHosts.nix

#-----------#
#  mkHosts  #
#-----------#

# Map over hosts defined in flake.nix and create nixosSystems for each.
#
# User identity/preferences come from flake.nix userDefs (pure data).
# User-specific HM modules come from users/<username>/ directories.
# Environment modules come from environment/ (shared across all users).
#
# Modules can be either:
#   - A plain HM module (function) → injected into HM only
#   - A dual-export attrset { nixos = <module>; home = <module>; } → nixos part
#     added as a NixOS module, home part injected into HM

{ inputs, lib, flakeRoot, ... }:

{ hosts, users }:

lib.mapAttrs (hostname: hostConfig:
  let
    pkgs = import inputs.nixpkgs {
      system = hostConfig.hostSettings.system;
      config.allowUnfree = true;
    };

    # Look up user data from flake.nix userDefs
    userDataAttrs = lib.listToAttrs (map (username:
      lib.nameValuePair username users.${username}
    ) hostConfig.users);

    # Users on this host whose vpn.autostart is true. Computed at eval time
    # from raw userDefs (defaults not yet applied, so use `or` fallbacks).
    # Consumed by the per-user vpn-veto script to detect "is another VPN
    # user logged in?" at login time.
    vpnAutostartUsers = lib.attrNames (lib.filterAttrs
      (_: u: u.networking.privacy.vpn.autostart or false)
      userDataAttrs);

    # Import module definition lists (each may contain plain or dual-export modules)
    envModules   = import "${flakeRoot}/environment";
    roleModules  = import "${flakeRoot}/modules/userSettings/roles";
    allModules   = envModules ++ roleModules;

    # Extract NixOS modules from dual-export files (skip HM-only modules)
    nixosFromDual = lib.concatMap (m:
      let mod = import m;
      in if builtins.isAttrs mod && mod ? nixos then [ mod.nixos ] else []
    ) allModules;

    # Extract HM modules from all files (dual-export → .home, plain → as-is)
    hmFromAll = lib.concatMap (m:
      let mod = import m;
      in if builtins.isAttrs mod && mod ? home then [ mod.home ]
         else if builtins.isFunction mod then [ m ]
         else []
    ) allModules;

    # HM modules: schema + flake HM modules + extracted home modules
    hmModules = [
      "${flakeRoot}/modules/userSettings/hm-schema.nix"
      inputs.hyprland.homeManagerModules.default
    ] ++ hmFromAll;

  in
  inputs.nixpkgs.lib.nixosSystem {
    system = hostConfig.hostSettings.system;
    specialArgs = { inherit inputs lib flakeRoot; };
    modules = [

    # Flake inputs as NixOS modules
      inputs.sops-nix.nixosModules.sops
      inputs.home-manager.nixosModules.home-manager
      inputs.nixvim.nixosModules.nixvim
      inputs.stylix.nixosModules.stylix
      inputs.hyprland.nixosModules.default

    # Schemas, system backend, host-specific config
      "${flakeRoot}/modules"
      "${flakeRoot}/system"
      "${flakeRoot}/hosts/${hostname}"

    # NixOS parts from dual-export modules (environment + roles)
    ] ++ nixosFromDual ++ [

    # Set hostSettings, userSettings, and stateVersion (NixOS-level)
      { config.hostSettings = hostConfig.hostSettings; }
      { config.userSettings = userDataAttrs; }
      { config.system.stateVersion = hostConfig.stateVersion; }

    # Set up Home Manager — inject HM parts per-user
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "bak";
          extraSpecialArgs = { inherit inputs flakeRoot vpnAutostartUsers; hostName = hostname; };
          users = lib.mapAttrs (username: userData: {
            imports = hmModules ++ [
              "${flakeRoot}/users/${username}"
            ];
            userSettings = userData;
            home.stateVersion = hostConfig.hmStateVersion or hostConfig.stateVersion;
            home.packages = [
              inputs.home-manager.packages.${hostConfig.hostSettings.system}.default
            ];
            programs.home-manager.enable = true;
          }) userDataAttrs;
        };
      }
    ];
  }
) hosts
