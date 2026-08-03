# flake.nix

#----------------------------------#
#  Hunter Thueson's NixOS Homelab  #
#----------------------------------#

# for high-level management of my NixOS homelab and its dependencies

{
  description = "Hunter Thueson's NixOS System Configuration(s)";

  #----------#
  #  Inputs  #
  #----------#

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";                           # Packages for Nix/NixOS

    sops-nix = {                                                                # Declarative secrets management via `sops`
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {                                                            # Declaratively manage users' home directories
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {                                                                  # Comprehensive theme engine
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {                                                                # Fast, flashy Wayland compositor
      url = "github:hyprwm/Hyprland";
    };

    nixvim = {                                                                  # Manage Neovim with Nix
      url = "github:nix-community/nixvim/nixos-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Fully-declarative Doom Emacs. Deliberately NOT `follows`-ing nixpkgs: it
    # pins its own emacs-overlay for binary-cache hits, so overriding would
    # force a local rebuild of every Emacs package.
    nix-doom-emacs-unstraightened.url = "github:marienz/nix-doom-emacs-unstraightened";
  };

  #-----------#
  #  Outputs  #
  #-----------#

  outputs = inputs @ { self, nixpkgs, sops-nix, home-manager, nixvim, stylix, ... }:

  let
    inherit (nixpkgs) lib;
    flakeRoot = ./.;
    inherit (import ./lib { inherit inputs lib flakeRoot; })
      mkHosts mkHomes keyboardPresets monitorPresets gpuPresets;

    #--------------------#
    #  User Definitions  #
    #--------------------#

    userDefs = {
      hunter = {
        nickname      = "Hunter";
        fullName      = "Hunter Thueson";
        email         = "hunter.thueson@gmail.com";
        administrator = true;
        role          = [ "wizard" "developer" "gamer" "filmmaker" "writer" ];
        shell         = "bash";
        editor        = { terminal = "vim"; gui = "emacs"; };
        desktop       = {
          environments = [ "hyprland" "niri" "plasma" ];
          colorScheme  = "electro-swing";
        };
        browser.name  = "firefox";
        fonts         = { sizes.terminal = 10; };
        sync.osrs     = true;

        networking.privacy = {
          vpn     = { enable = true; autostart = false; server = "USA-Denver"; };
          torrent = { enable = true; autostart = false; portForward = false; };
          tor     = { enable = true; autostart = false; };
        };
      };

      ash = {
        nickname      = "Ash";
        fullName      = "Ashley Ellison";
        email         = "ash.ellison@proton.me";
        administrator = true;
        role          = [ "wizard" "developer" "filmmaker" "writer" ];
        shell         = "bash";
        desktop       = {
          environments = [ "hyprland" "plasma" "plasmax11" ];
          colorScheme  = "electro-swing";
        };
        browser       = { name = "firefox"; declarative = false; };  # keep profile imperative

        networking.privacy = {
          vpn     = { enable = true; autostart = true;  server = "USA-Denver"; };
          torrent = { enable = true; autostart = false; portForward = false; };
          tor     = { enable = true; autostart = false; };
        };
      };
    };

    #--------------------#
    #  Host Definitions  #
    #--------------------#

    hostDefs = {
      hephaestus = {
        users = [ "hunter" "ash" ];
        stateVersion = "21.11";
        hmStateVersion = "25.11";

        hostSettings = {
          system = "x86_64-linux";
          type = "desktop";
          role = [ "workstation" "writing" ];
          loginManager = "sddm";
          availableSessions = [ "plasma" ];                                 # always available, on top of users' lists
          hardware = {
            boot = {
              loader = "systemd-boot";
              device = "/dev/disk/by-id/nvme-eui.0025384141427eb8";
            };
            gpu = [ gpuPresets."rtx3090" ];
            keyboard = {
              layout = "qwerty";
              model = keyboardPresets.zsa.moonlander;
            };
            display = monitorPresets.layouts."m28u-landscape--s2417dg-landscape-right";
          };
        };
      };

      artemis = {
        users = [ "hunter" ];
        stateVersion = "25.11";

        hostSettings = {
          system = "x86_64-linux";
          type = "laptop";
          role = [ "workstation" "writing" ];
          loginManager = "sddm";
          availableSessions = [ "plasma" ];                                 # always available, on top of users' lists
          hardware = {
            boot = {
              loader = "systemd-boot";
              device = "/dev/disk/by-uuid/F28D-FD6D";
            };
            keyboard = {
              layout = "qwerty";
              model = keyboardPresets.lenovoThinkPad."built-in";
            };
            display = {
              monitors = [ monitorPresets.lenovoThinkPad."built-in" ];
            };
          };
        };
      };
    };

  in
  {
    nixosConfigurations = mkHosts { hosts = hostDefs; users = userDefs; } // {
      installer = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          inputs.stylix.nixosModules.stylix
          inputs.hyprland.nixosModules.default
          inputs.nixvim.nixosModules.nixvim
          ./hosts/installer
        ];
      };
    };
    homeConfigurations  = mkHomes { hosts = hostDefs; users = userDefs; };
  };
}
