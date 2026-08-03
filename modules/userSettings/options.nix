# modules/userSettings/options.nix

#-----------#
#  Options  #
#-----------#

# Shared option definitions for userSettings.
# Used by both schema.nix (NixOS, attrsOf submodule) and hm-schema.nix (HM, single submodule).

{ lib, ... }:

let
  sessions = import ../../lib/sessions.nix;
in
{
  name        = lib.mkOption { type = lib.types.str; default = ""; };
  nickname    = lib.mkOption { type = lib.types.str; default = ""; };
  fullName    = lib.mkOption { type = lib.types.str; };
  email       = lib.mkOption { type = lib.types.nullOr lib.types.str; default = null; };

  administrator  = lib.mkOption { type = lib.types.bool; default = false; };
  extraGroups    = lib.mkOption { type = lib.types.listOf lib.types.str; default = []; };
  role = lib.mkOption {
    type = lib.types.listOf (lib.types.enum [
      "wizard"      # NixOS system administrator / power user
      "developer"   # software development tools and workflows
      "gamer"       # gaming-related user config
      "filmmaker"   # video editing, media production
      "writer"      # writing tools (org-roam, typst, etc.)
    ]);
    default = [];
  };

  hashedPasswordFile  = lib.mkOption { type = lib.types.nullOr lib.types.path; default = null; };

  terminal  = lib.mkOption { type = lib.types.enum [ "alacritty" ]; default = "alacritty"; };
  shell     = lib.mkOption { type = lib.types.enum [ "bash" "fish" "zsh" ]; default = "bash"; };
  enableGit = lib.mkOption { type = lib.types.bool; default = false; };

  editor = lib.mkOption {
    type = lib.types.submodule {
      options = {
        terminal = lib.mkOption { type = lib.types.enum [ "vim" "nano" ]; default = "vim"; };
        gui      = lib.mkOption { type = lib.types.enum [ "emacs" "kate" "vs-code" ]; default = "emacs"; };
      };
    };
    default = {};
  };

  # Mirrors Stylix's fonts.sizes so more categories (applications, desktop,
  # popups) can be added later without reshaping the schema.
  fonts = lib.mkOption {
    type = lib.types.submodule {
      options = {
        sizes = lib.mkOption {
          type = lib.types.submodule {
            options = {
              terminal = lib.mkOption {
                type        = lib.types.ints.positive;
                default     = 9;
                description = "Terminal font point size (feeds stylix.fonts.sizes.terminal).";
              };
            };
          };
          default = {};
        };
      };
    };
    default = {};
  };

  desktop = lib.mkOption {
    type = lib.types.submodule {
      options = {
        environments = lib.mkOption {
          type        = lib.types.listOf (lib.types.enum sessions.all);
          default     = [];
          description = ''
            Desktop sessions this user wants selectable at login on any host
            they're deployed to. Each host enables the union of its users'
            lists plus its own availableSessions.
          '';
        };
        theme = lib.mkOption {
          type        = lib.types.nullOr (lib.types.enum [ "default" ]);
          default     = null;
          description = "Set the user's theme (for window decorations, border styles, etc.)";
        };
        colorScheme = lib.mkOption {
          type        = lib.types.nullOr (lib.types.enum [ "electro-swing" ]);
          default     = null;
          description = "Set the user's color scheme";
        };
        wallpaper = lib.mkOption {
          type        = lib.types.nullOr lib.types.path;
          default     = null;
          description = "Set the user's wallpaper";
        };
      };
    };
  };

  sync = lib.mkOption {
    type = lib.types.submodule {
      options = {
        osrs = lib.mkOption {
          type        = lib.types.bool;
          default     = false;
          description = ''
            Keep this user's OSRS/RuneLite data (Bolt's RuneLite home) in sync
            across the hosts listed in environment/services/syncthing.nix.
          '';
        };
      };
    };
    default = {};
  };

  kdeconnect = lib.mkOption {
    type = lib.types.submodule {
      options = {
        enable = lib.mkOption {
          type        = lib.types.bool;
          default     = true;
          description = ''
            Run KDE Connect (phone integration: notifications, clipboard,
            file transfer, media control) in this user's graphical sessions.
            Applies to every session not listed in exceptSessions.
          '';
        };
        exceptSessions = lib.mkOption {
          type        = lib.types.listOf (lib.types.enum sessions.all);
          default     = [];
          description = ''
            Sessions where `enable` is inverted: with enable = true, the
            sessions that skip KDE Connect; with enable = false, the only
            sessions that run it.
          '';
        };
      };
    };
    default = {};
  };

  networking = lib.mkOption {
    type = lib.types.submodule {
      options = {
        privacy = lib.mkOption {
          type = lib.types.submodule {
            options = {
              vpn = lib.mkOption {
                type = lib.types.submodule {
                  options = {
                    enable = lib.mkOption {
                      type = lib.types.bool;
                      default = false;
                      description = ''
                        Permit this user to start/stop the host-wide IVPN
                        tunnel (ivpn-host.service). When the host tunnel is
                        up, ALL of this machine's traffic goes through IVPN.
                      '';
                    };
                    autostart = lib.mkOption {
                      type = lib.types.bool;
                      default = false;
                      description = ''
                        Start the host-wide tunnel at this user's login. When
                        false and `enable` is true, a veto unit fires at
                        login: if no other autostart-enabled user is logged
                        in, the host tunnel is stopped; otherwise it is left
                        alone with a notification.
                      '';
                    };
                    server = lib.mkOption {
                      type = lib.types.either lib.types.str (lib.types.submodule {
                        options = {
                          strategy = lib.mkOption {
                            type = lib.types.enum [ "single" ];
                            default = "single";
                            description = ''
                              Server selection strategy. Phase 1 only accepts
                              "single"; future phases add random / failover /
                              lowest-latency variants.
                            '';
                          };
                          name = lib.mkOption { type = lib.types.str; };
                        };
                      });
                      default = "";
                      description = ''
                        IVPN server config name (without .ovpn extension), e.g.
                        "USA-Denver". Resolved against
                        system/networking/ivpn/configs/<name>.ovpn.
                      '';
                    };
                  };
                };
                default = {};
              };

              torrent = lib.mkOption {
                type = lib.types.submodule {
                  options = {
                    enable = lib.mkOption {
                      type = lib.types.bool;
                      default = false;
                      description = ''
                        Install qBittorrent for this user and ensure the
                        always-on, namespace-isolated torrent tunnel
                        (ivpn-torrent.service) is configured on this host.
                      '';
                    };
                    autostart = lib.mkOption {
                      type = lib.types.bool;
                      default = false;
                      description = "Launch qBittorrent at this user's login.";
                    };
                    server = lib.mkOption {
                      type = lib.types.nullOr (lib.types.either lib.types.str (lib.types.submodule {
                        options = {
                          strategy = lib.mkOption {
                            type = lib.types.enum [ "single" ];
                            default = "single";
                          };
                          name = lib.mkOption { type = lib.types.str; };
                        };
                      }));
                      default = null;
                      description = ''
                        IVPN server config name for the torrent tunnel. When
                        null, falls back to this user's vpn.server.
                      '';
                    };
                    portForward = lib.mkOption {
                      type = lib.types.bool;
                      default = false;
                      description = "Request an IVPN port-forward at torrent start (for seeding).";
                    };
                  };
                };
                default = {};
              };

              tor = lib.mkOption {
                type = lib.types.submodule {
                  options = {
                    enable = lib.mkOption { type = lib.types.bool; default = false; };
                    autostart = lib.mkOption { type = lib.types.bool; default = false; };
                  };
                };
                default = {};
              };
            };
          };
          default = {};
        };
      };
    };
    default = {};
  };

  browser = lib.mkOption {
    type = lib.types.submodule {
      options = {
        name = lib.mkOption {
          type        = lib.types.enum [ "firefox" ];
          default     = "firefox";
          description = "Which browser to install and configure.";
        };
        declarative = lib.mkOption {
          type        = lib.types.bool;
          default     = true;
          description = ''
            Whether Home Manager manages this browser's profile (UI layout,
            about:config, extensions, theming). When false, HM still installs
            the browser but writes nothing to the profile, leaving it fully
            imperative — e.g. to protect a hand-configured profile.
          '';
        };
        extensions = lib.mkOption {
          type        = lib.types.listOf lib.types.str;
          default     = [];
          description = "List of browser extension/add-on IDs to install.";
        };
        profiles = lib.mkOption {
          type        = lib.types.attrs;
          default     = {};
          description = "Browser profiles";
        };
        policies = lib.mkOption {
          type        = lib.types.attrs;
          default     = {};
          description = "Policies";
        };
        settings = lib.mkOption {
          type        = lib.types.attrs;
          default     = {};
          description = "Browser-specific settings (about:config for Firefox, etc.)";
        };
        extraConfig = lib.mkOption {
          type        = lib.types.attrs;
          default     = {};
          description = "Extra HM programs.<browser> config to merge in.";
        };
      };
    };
    default = {};
  };

}
