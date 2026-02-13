# ./system/display/login-manager.nix

  #################################
  #  Login Manager Configuration  #
  #################################

{ config, pkgs, inputs, ... }:

# TODO: double-check that services.greetd.settings.default_session.command is set up correctly before usage
# NOTE: if any tui[OPTION] isn't working, check whether the escaped quotation marks are causing it

let 
  tuiTimeFormat = "\"%A, %Y- %-m- %d -- %-I: %M ... %S\"";
  tuiTheme = "\"border=red;text=magenta;time=red;container=black;prompt=magenta;input=red;greet=magenta;action=magenta;button=red\"";
  tuiGreeting = "\"\"Do not meddle in the affairs of wizards, for they are subtle and quick to anger.\" -J.R.R. Tolkien\"";
in

{

  services.displayManager.sddm.enable = true;     # keeping sddm for the time being, but once we get Hyprland up and running we'll switch to `tuigreet`
  services.greetd.enable = false;
  programs.regreet.enable = false;

  # greetd is a minimal and flexible login manager daemon. We will be using tuigreet as our greeter
  services.greetd = {
    useTextGreeter = true;                        # for tuigreet -- some systemd configuration will be adjusted to avoid interrupting TUI
    restart = true;                               # usually good to have on "true," but if you ever set up autologin this needs to be turned off
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet -g ${tuiGreeting} --time --time-format ${tuiTimeFormat} --theme ${tuiTheme} --asterisks --cmd start-hyprland";
        user = "greeter";
      };
    };
  };

  services.displayManager = {
    sddm = {
      enableHidpi = true;
      autoNumlock = true;
    };
  };
}
