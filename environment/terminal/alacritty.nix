# environment/terminal/alacritty.nix

#---------------------------#
#  Alacritty Configuration  #
#---------------------------#

# Pure HM module — works in both NixOS-managed and standalone HM.
# Configures Alacritty when userSettings.terminal == "alacritty"

{ config, pkgs, lib, ... }:

let
  user = config.userSettings;

in {
  config = lib.mkIf (user.terminal == "alacritty") {
    programs.alacritty = {
      enable = true;
      settings = {
        general.import = [
          "./colors/electro-swing.toml"
        ];

        window = {
          decorations = "none";
          dynamic_padding = true;
          opacity = lib.mkForce 0.97;
          title = "Alacritty";
          class = {
            general = "Alacritty";
            instance = "Alacritty";
          };
          padding = {
            x = 5;
            y = 4;
          };
        };

        cursor = {
          blink_interval = 600;
          blink_timeout = 30;
          thickness = 0.1;
          unfocused_hollow = true;
          style = {
            blinking = "On";
            shape = "Beam";
          };
          vi_mode_style = {
            blinking = "Off";
            shape = "Block";
          };
        };

        font = {
          size = lib.mkForce 9;
          bold = {
            family = "FiraCode Nerd Font";
            style = lib.mkForce "Retina Bold";
          };
          italic = {
            family = "FiraCode Nerd Font";
            style = lib.mkForce "Retina Italic";
          };
          normal = {
            family = "FiraCode Nerd Font";
            style = lib.mkForce "Retina";
          };
        };
      };
    };
  };
}
