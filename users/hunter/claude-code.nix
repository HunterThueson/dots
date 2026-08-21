# users/hunter/claude-code.nix
#
# Hunter's per-user Claude Code config: settings, keybindings, and skills.
# Shared install (developer-gated `enable`) lives in
# environment/services/claude-code.nix.
#
# The actual content is sourced from the private `claude-config` flake input,
# so personal settings/prompts stay out of this public repo. This file is only
# wiring — it reads from the input and hands the pieces to Home Manager. [1]

{ config, lib, inputs, ... }:

let
  isDeveloper = builtins.elem "developer" config.userSettings.role;
  src = inputs.claude-config;
in {
  config = lib.mkIf isDeveloper {

    # settings.json is now HM-owned (read-only symlink), so `/model` and
    # `/config` no longer persist at runtime — change these via the input. [1]
    programs.claude-code.settings = lib.importJSON "${src}/settings.json";
    programs.claude-code.skills = "${src}/skills";

    # keybindings.json has no HM option, so place it directly.
    home.file.".claude/keybindings.json".source = "${src}/keybindings.json";
  };
}

#-------------#
#  Footnotes  #
#-------------#

# 1: `claude-config` is a `git+file` input (~/projects/claude-config), so it
#    locks to a commit — an edit there isn't picked up until it's committed and
#    the input is re-locked:
#      cd ~/projects/claude-config && git commit -am "…"
#      nix flake update claude-config    # in /etc/nixos
#      sudo nixos-rebuild switch --flake .#<host>
#    The tradeoff bought by the input is privacy (content off the public repo);
#    switching the URL to a private `github:HunterThueson/claude-config` would
#    add portability across hosts but needs a GitHub token in Nix's
#    access-tokens (sops-managed) because `nixos-rebuild` fetches as root.
#
#    First switch: HM replaces the pre-existing ~/.claude/{settings.json,
#    keybindings.json,skills/fix-comments} with store symlinks. Under
#    nixos-rebuild the originals are saved as *.bak (mkHosts' backupFileExtension);
#    a standalone `home-manager switch` (mkHomes sets no backup extension)
#    aborts on the collision instead, so move those originals aside first.

# EOF
