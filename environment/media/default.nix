# environment/media/default.nix

# List of media-production module paths.
# Each file is a dual-export { nixos; home; }, gated on the "filmmaker" role.

[
  ./screen-capture.nix
  ./video-editor.nix
]
