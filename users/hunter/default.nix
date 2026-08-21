# users/hunter/
#
# User-specific HM modules for Hunter.
# These are imported into Hunter's Home Manager config alongside
# the shared environment/ modules.

{ pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./services.nix
    ./firefox.nix
    ./claude-code.nix
  ];
}
