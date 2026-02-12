# ./system/services/mouse-and-keyboard.nix

  ######################################
  #  Mouse and Keyboard Configuration  #
  ######################################

{ config, pkgs, inputs, ... }:

{
  services.xserver = {
    enable = true;                                                              # Enable the X11 windowing system
    exportConfiguration = true;                                                 # Symlink the X server configuration under /etc/X11/xorg.conf
    xkb = {
      options = "ctrl:nocaps";                                                  # Disable CAPS Lock & replace with Ctrl
      layout = "us";                                                            # Configure X11 keymap layout
    };
  };

  services.libinput = {
    enable = true;                                                              # Enable touchpad support
    mouse.accelProfile = "flat";                                                # Disable mouse acceleration (bad for gaming)
  };
}
