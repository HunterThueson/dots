# users/hunter/firefox.nix
#
# Hunter's per-user Firefox: bookmarks, search engines, and userChrome CSS.
# Shared setup lives in environment/browser/firefox.nix.
#
# Fill each block in as you rebuild the profile, then rebuild to capture it.
# `force = true` hands the underlying file to HM — once set, changes made in the
# running browser are overwritten on the next switch. Leave a block commented
# until you're ready to hand it over, so in-browser setup isn't wiped mid-rebuild.

{ config, lib, hostName, ... }:

let
  browser = config.userSettings.browser;
in {
  config = lib.mkIf (browser.name == "firefox" && browser.declarative) {
    programs.firefox.profiles.default = {

      # -- Search engines (uncomment when ready) ---------------------------
      # `definedAliases` are the `@keyword`s typed in the URL bar.
      # search = {
      #   force   = true;                    # hand search.json.mozlz4 to HM
      #   default = "google";
      #   order   = [ "google" "nix-packages" ];
      #   engines = {
      #     "nix-packages" = {
      #       name = "Nix Packages";
      #       urls = [{
      #         template = "https://search.nixos.org/packages";
      #         params = [
      #           { name = "type";  value = "packages"; }
      #           { name = "query"; value = "{searchTerms}"; }
      #         ];
      #       }];
      #       definedAliases = [ "@np" ];
      #     };
      #   };
      # };

      # -- Bookmarks (uncomment when ready) --------------------------------
      # Folders nest via `bookmarks = [ ... ]`; `keyword` = URL-bar shortcut.
      # bookmarks = {
      #   force    = true;                    # hand places.sqlite to HM
      #   settings = [
      #     { name = "NixOS Manual"; url = "https://nixos.org/manual/nixos/stable/"; keyword = "nixman"; }
      #   ];
      # };

      # -- Chrome CSS (uncomment when ready) -------------------------------
      # userChrome = '''';

      # -- Display scaling -------------------------------------------------
      # hephaestus forces Firefox onto XWayland (see its configuration.nix),
      # where the 4K M28U hands Firefox a 1.0 device-pixel ratio and the UI
      # renders tiny; nudge it back up. Host-scoped so artemis (native Wayland,
      # its own scale) stays untouched.
      settings = lib.mkIf (hostName == "hephaestus") {
        "layout.css.devPixelsPerPx" = "1.1";
      };

    };
  };
}
