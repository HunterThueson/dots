# environment/default.nix

# Master list of environment module paths.
# Imported by both mkHosts.nix and mkHomes.nix.
#
# Each entry resolves to either:
#   - A plain HM module (function)        → injected into HM only
#   - A dual-export { nixos; home; }       → nixos part added to NixOS, home part to HM
#
# Directories with multiple modules return a list (via import);
# directories whose default.nix IS the module are listed as paths.

(import ./browser) ++           # [ firefox ] — HM modules
(import ./desktop) ++           # [ hyprland, plasma ] — dual-export
(import ./media) ++             # [ obs ] — dual-export, gated on "filmmaker"
(import ./services) ++          # [ privacy ] — dual-export
(import ./terminal) ++          # [ alacritty ] — HM modules
(import ./themes) ++            # [ fonts, stylix ] — dual-export
[
  ./dev                         # git — HM module
  ./editor                      # emacs + vim — dual-export
  ./games                       # steam, osrs — dual-export
  ./shell                       # bash, starship, zsh/fish enabling — dual-export
]
