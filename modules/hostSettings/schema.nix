# modules/hostSettings/schema.nix

#----------#
#  Schema  #
#----------#

{ lib, pkgs, ... }:

let
  sessions = import ../../lib/sessions.nix;
in
{
  options.hostSettings = lib.mkOption {
    type = lib.types.submodule {
      options = {
        system = lib.mkOption { type = lib.types.enum [ "x86_64-linux" "aarch64-linux" ]; };
        type   = lib.mkOption { type = lib.types.enum [ "desktop" "laptop" "server" ]; };
        role   = lib.mkOption { type = lib.types.listOf (lib.types.enum [ "workstation" "writing" "media" "server" ]); };

        loginManager = lib.mkOption {
          type = lib.types.enum [ "greetd" "sddm" ];
          default = "sddm";
        };

        availableSessions = lib.mkOption {
          type        = lib.types.listOf (lib.types.enum sessions.all);
          default     = [];
          description = ''
            Desktop sessions always available on this host, regardless of what
            its users request. Unioned with the users' desktop.environments
            lists to decide which sessions the host enables.
          '';
        };

        hardware = lib.mkOption { type = lib.types.submodule (import ./hardware-options.nix); };

        networking = lib.mkOption {
          type = lib.types.submodule {
            options = {
              privacy = lib.mkOption {
                type = lib.types.submodule {
                  options = {
                    vpn = lib.mkOption {
                      type = lib.types.submodule {
                        options = {
                          autostart = lib.mkOption {
                            type = lib.types.bool;
                            default = false;
                            description = ''
                              Start the host-wide IVPN tunnel
                              (ivpn-host.service) at boot, before any user
                              logs in. User-level `autostart=false` does not
                              actively veto this when another autostart-user
                              is concurrently logged in.
                            '';
                          };
                        };
                      };
                      default = {};
                    };
                    torrent = lib.mkOption {
                      type = lib.types.submodule {
                        options = {
                          autostart = lib.mkOption {
                            type = lib.types.bool;
                            default = true;
                            description = ''
                              Start the always-on torrent namespace tunnel
                              (ivpn-torrent.service) at boot. Default true:
                              the namespace tunnel comes up whenever any user
                              has `torrent.enable` set.
                            '';
                          };
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
      };
    };
  };
}
