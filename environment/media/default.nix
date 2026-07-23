# environment/media/default.nix

# List of media-production module paths.
# Each file is a dual-export { nixos; home; }, gated on the "filmmaker" role.

[
  ./obs.nix
  ./kdenlive.nix
  ./davinci-resolve.nix
]
