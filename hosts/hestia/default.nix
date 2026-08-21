# hosts/hestia/default.nix

{ ... }:

{
  imports = [
    ./configuration.nix
    ./hardware.nix
  ];
}
