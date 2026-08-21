# environment/services/claude-code.nix

#---------------#
#  Claude Code  #
#---------------#

# Anthropic's official CLI, installed for anyone with the developer role.
# home-only: it's a per-user tool with no invisible system plumbing — no
# daemon, firewall, or group to manage — so the perceptual boundary puts it
# in environment/ as HM-only. Kept in the dual-export attrset shape (like
# privacy.nix) so a nixos half can be added later if one ever earns it. [1]
#
# This module only installs the CLI and enables it; it writes nothing under
# ~/.claude itself. Per-user declarative config layers on top from
# users/<name>/ (e.g. users/hunter/claude-code.nix). [2]

{
  home = { config, lib, ... }:
  let
    isDeveloper = builtins.elem "developer" config.userSettings.role;
  in {
    config = lib.mkIf isDeveloper {
      programs.claude-code.enable = true;
    };
  };
}

#-------------#
#  Footnotes  #
#-------------#

# 1: There's no genuine system-level concern to split out. The package is a
#    per-user install (HM profile, matching the "packages via HM" norm), the
#    config lives under ~/.claude, and it only ever makes outbound HTTPS. A
#    nixos half would earn its place if, say, the `claude` binary should be
#    available to root / non-HM shells (environment.systemPackages) or a
#    host-wide setting appears — add `nixos = { ... }` here then, rather than
#    scattering it into system/.

# 2: The upstream programs.claude-code module writes ~/.claude/settings.json
#    (and CLAUDE.md, agents/, skills/, hooks/ …) as read-only store symlinks,
#    but only for whichever of those options are non-empty; with all of them
#    at their defaults it writes nothing under ~/.claude and just installs the
#    package. Keeping this shared module at enable-only means a developer with
#    no users/<name>/claude-code.nix (e.g. ash) still gets a fully hand-managed
#    ~/.claude. Per-user declarative config follows the shared/per-user split
#    the Firefox modules use — hunter's lives in users/hunter/claude-code.nix,
#    sourced from a private flake input. Whatever a user doesn't declare there
#    (hooks, per-project memory, credentials) stays imperative.

# EOF
