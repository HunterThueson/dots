# ./system/display/fonts.nix

########################
#  Font Configuration  #
########################

{ config, pkgs, inputs, ... }:

{
  console.font = "Lat2-Terminus16";

  fonts = {
    fontDir.enable = true;                                                      # Enable /nix/var/nix/profiles/system/sw/share/X11/fonts
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.fira-mono
      nerd-fonts.hack
      nerd-fonts.arimo
      nerd-fonts.im-writing
    ]; 
    fontconfig.defaultFonts = {
      monospace = [ "FiraCode Nerd Font" ];
    };
  };
}
