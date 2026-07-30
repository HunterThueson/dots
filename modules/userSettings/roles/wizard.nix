# ./modules/userSettings/roles/wizard.nix

#-----------#
#  Wizards  #
#-----------#

# Dual-export module for the wizard role.
# nixos: defines the wizard group, ensures /etc/nixos/ permissions
# home:  adds the `cdn` shell function for quick access to /etc/nixos/
#        and enables git automatically unless explicitly disabled

{
  nixos = { config, ... }: {
    users.groups.wizard.gid = 1001;

    system.activationScripts.wizardPermissions = ''
      chown -R root:wizard /etc/nixos
      chmod -R g+rwX /etc/nixos
    '';
  };

  home = { config, lib, pkgs, ... }:
  let
    isWizard = builtins.elem "wizard" config.userSettings.role;
  in {
    config = lib.mkIf isWizard {
      programs.git.enable = lib.mkDefault true;

      programs.bash.bashrcExtra = ''
        # Teleport to NixOS configuration directory
        cdn () {
          cd /etc/nixos/
          clear
          eza --icons=auto --group-directories-first
        }

        # Garbage-collect Nix, keeping the last N generations (default 5) of the
        # system, Home Manager, and personal nix-env profiles, then free space.
        ngc () {
          local keep="+''${1:-5}"
          local hm="$HOME/.local/state/nix/profiles/home-manager"
          local usr="$HOME/.local/state/nix/profiles/profile"
          sudo nix-env -p /nix/var/nix/profiles/system --delete-generations "$keep"
          [ -e "$hm"  ] && nix-env -p "$hm"  --delete-generations "$keep"
          [ -e "$usr" ] && nix-env -p "$usr" --delete-generations "$keep"
          nix-collect-garbage
        }
      '';

      home.sessionPath = [
        "/etc/nixos/scripts"
      ];

      home.packages = with pkgs; [
        nh
        sops
        age
        ssh-to-age
      ];
    };
  };
}
