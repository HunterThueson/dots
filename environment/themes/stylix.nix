# environment/themes/stylix.nix

#------------------------#
#  Stylix Configuration  #
#------------------------#

# Color schemes, fonts, and theming — the user perceives all of it.

let
  # Shared by both blocks so `nixos-rebuild` and `home-manager switch`
  # produce identical theming. [2]
  # TODO: wire to userSettings.desktop.colorScheme
  colorScheme = ./colors/electro-swing.yaml;

  # Font families only — sizes are set per-block (system default vs per-user)
  sharedFonts = pkgs: {
    serif = {
      package = pkgs.nerd-fonts.sauce-code-pro;
      name = "Source Code Pro Nerd Font";
    };

    sansSerif = {
      package = pkgs.nerd-fonts.sauce-code-pro;
      name = "Source Code Pro Nerd Font";
    };

    monospace = {
      package = pkgs.nerd-fonts.fira-code;
      name = "FiraCode Nerd Font";
    };

    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };
  };

in {
  nixos = { pkgs, lib, ... }: {
    stylix = {
      enable = true;

      base16Scheme = colorScheme;

      fonts = sharedFonts pkgs // {
        sizes.terminal = 9;   # system-level default; per-user values win at the HM level [2]
      };

      targets = {
        nixvim = {
          enable = true;
          plugin = "mini.base16";
        };

        # Plasma-native Qt theming — Breeze + `org.kde.desktop`. [1]
        qt.platform = lib.mkForce "kde";
      };
    };
  };

  home = { config, pkgs, lib, ... }: {
    stylix = {
      enable = true;   # standalone HM has no system to follow [2]

      base16Scheme = colorScheme;

      fonts = sharedFonts pkgs // {
        sizes.terminal = config.userSettings.fonts.sizes.terminal;
      };

      # Pinned to the values the integrated path resolves to. [3]
      targets.qt = {
        enable = true;
        platform = lib.mkForce "kde";
      };
    };
  };
}


#-------------#
#  Footnotes  #
#-------------#

# 1: `platform` is forced to "kde" for Plasma-native Qt theming (Breeze widget
#    style + the `org.kde.desktop` Quick Controls style). Setting "kde" makes
#    `nixos-rebuild` print a persistent warning that "kde" isn't a fully
#    supported platform value; that warning is knowingly left in place. The
#    obvious way to silence it is to set "qtct" instead — but "qtct" selects the
#    qt5ct/Kvantum path (`recommendedStyle.qtct = "kvantum"`), loading a
#    `kvantum` QtQuick.Controls style into the session. plasmashell ships no such
#    QML module, so its `import QtQuick.Controls` calls fail and the shell renders
#    black (panels, widgets, and wallpaper vanish while kwin still draws normal
#    windows). That is the tradeoff behind tolerating the warning.
#
# 2: The two rebuild paths reach Home Manager differently: `nixos-rebuild`
#    (lib/mkHosts.nix) auto-imports Stylix into each user and copies the system
#    settings down via followSystem (as mkDefault), whereas `home-manager switch`
#    (lib/mkHomes.nix) builds standalone with no system to follow. Without the
#    `home` block, standalone evaluates with `stylix.enable = false` and every
#    HM target (gtk, cursor, firefox, alacritty, …) inert — the fast path would
#    silently un-theme the user until the next full rebuild. Setting the shared
#    values here at normal priority makes standalone self-sufficient and
#    harmlessly overrides the identical followSystem defaults in the integrated
#    path. Per-user font sizes ride the same mechanism: the home block reads
#    userSettings, beating the system-level mkDefault in both paths. Full design
#    analysis: docs/rebuild-paths-and-per-user-config.md.
#
# 3: Stylix's HM qt target auto-enables only when `nixosConfig != null`, so the
#    `enable = true` above doesn't reach it standalone; it is pinned here to
#    what the integrated path resolves to (enable = true, platform = "kde").
#    The platform pin matters: left unset, standalone could fall through to
#    "qtct" — the Kvantum black-screen path described in footnote 1.
