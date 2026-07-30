# environment/editor/default.nix

#-----------#
#  Editors  #
#-----------#

# Dual-export: system-level enabling + per-user HM config in one place.
# nixos: nixvim system-wide + the Emacs package binary cache
# home:  per-user editor config (nixvim, declarative Doom Emacs)

{
  nixos = { config, lib, ... }:
  let
    users = lib.attrValues config.userSettings;
    anyWantsEmacs = lib.any (u: u.editor.gui == "emacs") users;
  in {
    # Vim/nixvim handles its own conditional via anyUserWantsVim
    imports = [ ./vim ];

    # Emacs is now fully per-user via Home Manager (see ./emacs — a declarative
    # Doom build). The only thing worth doing system-wide is trusting the cache
    # its Emacs packages are built on, so they download prebuilt rather than
    # compiling locally. Mirrors the hyprland cachix setup.
    config = lib.mkIf anyWantsEmacs {
      nix.settings = {
        substituters         = [ "https://nix-community.cachix.org" ];
        trusted-substituters = [ "https://nix-community.cachix.org" ];
        trusted-public-keys  = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
      };
    };
  };

  home = { ... }: {
    imports = [ ./emacs ];
  };
}
