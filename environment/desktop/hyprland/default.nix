# environment/desktop/hyprland/default.nix

#-----------------------------------------#
#  Hyprland Window Manager Configuration  #
#-----------------------------------------#

# Dual-export module: NixOS enables Hyprland system-wide,
# HM configures per-user session with Lua config.
#
# The HM Hyprland module only generates Hyprlang (.conf).
# Hyprland 0.55+ loads hyprland.lua first and ignores .conf,
# so we place our Lua config via xdg.configFile.

{
  nixos = { config, pkgs, lib, inputs, ... }:
  let
    sessions = import ../../../lib/sessions.nix;
    enabled = sessions.forHost {
      inherit (config) hostSettings;
      users = lib.attrValues config.userSettings;
    };
  in {
    config = lib.mkIf (lib.elem "hyprland" enabled) {

      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        withUWSM = false;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
      };

      environment.systemPackages = with pkgs; [
        brightnessctl
        dunst
        grim
        libnotify
        networkmanagerapplet
        playerctl
        slurp
        awww
        waybar
        wl-clipboard
        wlr-protocols
        kdePackages.wayland-protocols
      ];

      # Cachix so we don't have to build Hyprland from source
      nix.settings = {
        substituters = ["https://hyprland.cachix.org"];
        trusted-substituters = ["https://hyprland.cachix.org"];
        trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      };
    };
  };

  home = { config, pkgs, lib, inputs, ... }:
  let
    userSessions = config.userSettings.desktop.environments;
  in {
    config = lib.mkIf (lib.elem "hyprland" userSessions) {

      xdg.portal = {
        config.common.default = "*";
        extraPortals = [ inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland ];
      };

      wayland.windowManager.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd = {
          enable = true;
          enableXdgAutostart = true;
          variables = [ "--all" ];
        };
        package = null;       # Use the NixOS module's package
        portalPackage = null;

        # Pin the legacy hyprlang mode so `extraConfig` stays a Hyprlang comment. [1]
        configType = "hyprlang";

        # Suppress HM warning about empty config -- actual config is in hyprland.lua
        extraConfig = "# Config managed via hyprland.lua";
      };

      # Lua config
      xdg.configFile."hypr/hyprland.lua".source = ./hyprland.lua;

      programs.rofi = {
        enable = true;
        package = pkgs.rofi;
      };

      programs.hyprlock.enable = true;
      programs.hyprshot = {
        enable = true;
        saveLocation = "$HOME/images/screenshots";
      };

      # Waybar (until Quickshell implementation)
      programs.waybar = {
        enable = true;
        settings = [{
          layer = "top";
          position = "top";
          height = 25;
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "clock" ];
          modules-right = [ "pulseaudio" "network" "cpu" "memory" "tray" "battery" ];
          "hyprland/workspaces" = { format = "{id}"; };
          clock = { format = "{:%a %b %d  %I:%M %p}"; };
          pulseaudio = {
            format = "{icon} {volume}%";
            format-icons.default = ["" "" ""];
          };
          network = {
            format-wifi = " {essid}";
            format-ethernet = " {ifname}";
            format-disconnected = "Disconnected";
          };
          cpu.format = " {usage}%";
          memory.format = " {}%";
          tray = { spacing = 10; };
          battery = {
            format = "{icon} {capacity}%";
            format-icons.default = ["" "" ""];
          };
        }];
      };

      # Dunst (until Quickshell implementation)
      services.dunst = {
        enable = true;
        settings = {
          global = {
            width = 300;
            height = 100;
            offset = "30x50";
            origin = "top-right";
            corner_radius = 10;
          };
          urgency_low.timeout = 5;
          urgency_normal.timeout = 10;
          urgency_critical.timeout = 0;
        };
      };

      home.packages = [
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
      ];
    };
  };
}

#-----------#
# Footnotes #
#-----------#

# 1: HM 26.05 flipped the default to "lua", but the actual lua config is
#    placed via xdg.configFile below — setting configType="lua" would make
#    HM emit its own hyprland.lua from `extraConfig` and clash with ours.

# EOF
