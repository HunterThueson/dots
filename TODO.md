# TODO

## Emacs Configuration

It's high time I actually switch to Emacs. I NEED `org-mode`, `org-roam`, and `org-agenda` functionality in my life ASAP, but the learning curve from `nvim` to Emacs has, thus
far, been too steep. Let's oil the hinges a bit and make transitioning as easy & seamless as possible.

1) I need to figure out my keybindings once and for all. Then, once they're set in stone, stick with it and learn it and make it all muscle-memory.

## Miscellaneous Fixes & Adjustments

### `nvim`

* Color highlighting (i.e. if I type "grey" it highlights the word with the given color) should only ever be active if ALL the following conditions are met:

    a) the current buffer is NOT a Markdown or `org` or `.toml`/`.yaml` file -- those filetypes are the only time color highlighting should ever be active, since the only reason I want color
    highlighting is for reference in READMEs or for easy viewing of changes in config files (which are usually `.toml` or `.yaml` files).

    b) the word is by itself, i.e. if the text is `grey` then enable color highlighting; if it's `"grey"` enable color highlighting; if it's `greyhound` disable color
    highlighting; etc.

    c) (if possible to implement): the word is not currently in the process of being written. For instance, right now, when I write the word `greyhound`, color highlighting is disabled while I begin the
    word, then activates for a split second when I've typed `grey` and am reaching for the `h` key, then is disabled again once I've typed `greyh` -- this is very annoying
    while editing files. I'd much rather have no color highlighting whatsoever until I've written `grey ` (i.e. I've written "grey" with a trailing `SPACE`, signifying that I meant
    to type the word `grey` only and have moved on to the next word). In short: color highlighting should only ever be applied to FINISHED words, not words I'm actively
    typing.

  If I'm not able to meet ALL of those conditions, let's just disable color highlighting entirely outside of configuration files (`*.toml`, `*.yaml`, `*.cfg`, etc.)

* Let's set `textwidth=171` by default for all whitespace-insensitive files (like `*.nix` or `*.md` or `*.org` files). Whitespace-sensitive files should not wrap at all, but I
  DO want to `set linebreak` by default so that if I decide I need to wrap text temporarily, I can just `:set wrap` and get the behavior I want (which is `:set wrap
  linebreak`) without having to type out `:set wrap linebreak` every time. `:set wrap` is much faster and easier.

### SDDM Configuration & Theme

* Clock should be shown in `2:34 PM` format instead of `14:34` format

* Colors should follow the `electro-swing` color palette -- specifically, let's use the dark grey background color defined in the `electro-swing` instead of the current light
  grey

* The username box still auto-fills the last user to log in -- I would prefer that both boxes start empty on every new instance of the greeter. Blank username, blank password
  box, every time (no matter whether cold boot or reboot or logout/switch-user).

* The current configuration has the M28U monitor on the right of the "virtual layout" (or whatever the proper term is), while the Dell S2417DG is on the left -- that's the
  opposite of what I want. I want the monitor layout to match what I've defined for `hephaestus`. Additionally, the "focus" always starts on the Dell right now (meaning that
  if I start typing my username/password without touching anything, the boxes displayed on the S2417DG are the ones that receive input by default, like it's the "primary"
  monitor or something) -- I'd prefer the focus to start on the M28U (my actual day-to-day "primary" (most-used) monitor) instead.

### Firefox & OSRS Interactions

* The `Lookup Wiki` button in Runelite (under the minimap -- click the button and then an item to look it up on the wiki in a new Firefox window) currently creates its own Firefox profile
  instead of using the user's default Firefox profile. This creates unnecessary bloat with a new window on the screen every time I want to look something up. If there's a way to force
  Runelite/OSRS/Bolt Launcher to use a Firefox profile of my choice instead (I'm not sure which one of the three is the culprit), that'd be a very big annoyance off my shoulders.
