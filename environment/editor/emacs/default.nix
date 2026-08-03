# environment/editor/emacs/default.nix

#-----------------------#
#  Emacs Configuration  #
#-----------------------#

# Pure HM module — works in both NixOS-managed and standalone HM.
# Runs a fully-declarative Doom Emacs (nix-doom-emacs-unstraightened) when
# userSettings.editor.gui == "emacs". The Doom config itself lives in ./doom;
# users with the "writer" role additionally get the prose setup in ./doom-writer.

{ config, lib, pkgs, inputs, ... }:

let
  user = config.userSettings;
  isWriter = builtins.elem "writer" user.role;

  # Writers get an extended doomDir: the base ./doom config plus the prose
  # module from ./doom-writer. doomDir must be a single path, so the merge
  # happens at build time — packages.el gains the writer packages and prose.el
  # appears alongside config.el (which `load!`s it with NOERROR, so non-writer
  # builds simply skip it).
  doomDir =
    if isWriter then
      pkgs.runCommandLocal "doom-config-writer" {} ''
        mkdir -p $out
        cp --no-preserve=mode ${./doom}/* $out/
        cp --no-preserve=mode ${./doom-writer}/prose.el $out/
        cat ${./doom-writer}/packages.el >> $out/packages.el
      ''
    else ./doom;

  # A base16 theme generated from the active Stylix palette, so Emacs matches
  # the rest of the system (same approach as the nixvim mini.base16 target).
  # This replicates Stylix's own emacs target, which we can't use directly: it
  # hooks programs.emacs, and we drive Emacs through programs.doom-emacs. [1]
  stylixTheme = epkgs: epkgs.trivialBuild (
    with config.lib.stylix.colors.withHashtag; {
      pname = "base16-stylix-theme";
      version = "0.1.0";
      packageRequires = [ epkgs.base16-theme ];
      src = pkgs.writeText "base16-stylix-theme.el" ''
        (require 'base16-theme)

        ;; Bake the real palette into the 256-color (terminal) face specs too,
        ;; instead of the terminal's 16 ANSI names. Must precede
        ;; base16-theme-define, which reads this when it builds the specs. [3]
        (setq base16-theme-256-color-source 'colors)

        (defvar base16-stylix-theme-colors
          '(:base00 "${base00}" :base01 "${base01}" :base02 "${base02}" :base03 "${base03}"
            :base04 "${base04}" :base05 "${base05}" :base06 "${base06}" :base07 "${base07}"
            :base08 "${base08}" :base09 "${base09}" :base0A "${base0A}" :base0B "${base0B}"
            :base0C "${base0C}" :base0D "${base0D}" :base0E "${base0E}" :base0F "${base0F}")
          "All colors for base16-stylix are defined here.")

        (deftheme base16-stylix)
        (base16-theme-define 'base16-stylix base16-stylix-theme-colors)
        (provide-theme 'base16-stylix)

        (add-to-list 'custom-theme-load-path
          (file-name-directory (file-truename load-file-name)))

        (provide 'base16-stylix-theme)
      '';
    }
  );

in {
  # Provides the programs.doom-emacs option set in both HM build paths.
  imports = [ inputs.nix-doom-emacs-unstraightened.homeModule ];

  config = lib.mkIf (user.editor.gui == "emacs") {
    programs.doom-emacs = {
      enable = true;
      emacs = pkgs.emacs-pgtk;                                      # native Wayland (Hyprland)
      inherit doomDir;                                              # ./doom, plus ./doom-writer for the writer role
      doomLocalDir = "${config.home.homeDirectory}/.local/share/doom";

      # Build the Stylix theme in both HM paths. environment/themes/stylix.nix
      # sets stylix.base16Scheme in its `home` block, so config.lib.stylix.colors
      # resolves under `home-manager switch' as well as `nixos-rebuild' — no
      # config.stylix.enable guard needed. config.el still `require's the theme
      # defensively and falls back to a Doom theme if it's ever absent. [2]
      extraPackages = epkgs: [ (stylixTheme epkgs) ];
    };

    # Run the Emacs daemon with the graphical session. Unstraightened registers
    # itself as services.emacs.package, so this launches the Doom build.
    services.emacs.enable = true;

    # Native dependencies for org-roam and other packages
    home.packages = with pkgs; [
      sqlite                                    # org-roam database
      ripgrep                                   # faster searching (used by various packages)
      graphviz                                  # org-roam graph visualization
      fd                                        # faster find (projectile, etc.)
      (aspellWithDicts (ds: [ ds.en ds.en-computers ds.en-science ]))  # spell checking
    ] ++ lib.optionals isWriter [
      literata                                  # variable-pitch serif for prose (doom-writer/prose.el)
    ];

    # Ensure org-roam directory exists
    home.file."docs/.keep".text = "";
  };
}


#-------------#
#  Footnotes  #
#-------------#

# 1: config.lib.stylix.colors.withHashtag gives the base16 palette as "#rrggbb"
#    strings. base16-theme (a MELPA package pulled in via packageRequires) turns
#    that 16-color plist into a full set of faces. The theme file adds its own
#    directory to custom-theme-load-path on load, so Doom's `load-theme` can
#    find 'base16-stylix (see doom/config.el).
#
# 2: Both HM build paths get the palette. environment/themes/stylix.nix sets
#    stylix.base16Scheme in BOTH its `nixos` and `home` blocks; the `home` one
#    reaches standalone mkHomes (which has no system to follow), while mkHosts
#    gets it via Stylix's followSystem. Stylix assigns config.lib.stylix.colors
#    unconditionally once base16Scheme is set (it does not require
#    stylix.enable), so the theme builds the same way under either path.
#
# 3: base16-theme-define bakes a separate face spec for 256-color terminals. Its
#    default (`terminal') emits the 16 ANSI color names, so a `-nw' frame ignores
#    the Stylix palette and shows the terminal's own colors instead. Setting the
#    source to `colors' first bakes the real hexes into that branch too, so
#    terminal Emacs matches the GUI. (Note: with a 256-color TERM like Alacritty,
#    Emacs approximates to the nearest xterm-256 cell; a truecolor terminfo such
#    as `alacritty-direct' would render them exactly.)
