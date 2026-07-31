# environment/services/default.nix
#
# Service modules that participate in the dual-export pattern.
# Each entry resolves to either a plain HM module or a dual-export
# { nixos; home; } attrset.

[
  ./privacy.nix
  ./syncthing.nix
]
