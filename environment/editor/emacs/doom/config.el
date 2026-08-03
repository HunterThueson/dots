;;; config.el -*- lexical-binding: t; -*-

;; environment/editor/emacs/doom/config.el
;;
;;  /---------------------------\
;; >  Doom Emacs — Personal Cfg  <
;;  \---------------------------/
;;
;;  Loaded on every startup. Unlike init.el, most changes here take effect on
;;  `M-x doom/reload' (SPC h r r) without a Nix rebuild. Use `after!' to
;;  configure a package once it loads, and `setq' for plain variables.

;;  -------------------------
;;  |  Appearance & Theme   |
;;  -------------------------

;; Base16 theme generated from the Stylix palette (see ../default.nix). It's
;; built in both HM paths (nixos-rebuild and standalone home-manager switch), so
;; this normally always loads; the NOERROR `require' is just defensive, falling
;; back to Doom's default theme if the package is ever absent. Loading the theme
;; puts its directory on custom-theme-load-path so `doom-theme' resolves.
;; (The 256-color-terminal palette is baked into the theme itself — see
;; ../default.nix — so a `-nw' frame renders the same as the GUI.)
(when (require 'base16-stylix-theme nil t)
  (setq doom-theme 'base16-stylix))

;; Font — matches Stylix's monospace (FiraCode Nerd Font). Size is the one value
;; not auto-synced from Stylix; tweak to taste.
(setq doom-font (font-spec :family "FiraCode Nerd Font" :size 14))

;; Relative, visual line numbers (carried over from the old config).
(setq display-line-numbers-type 'visual)

;; Show available keys quickly after a prefix (you had 0.05 before).
(setq which-key-idle-delay 0.05)

;;  --------------
;;  |  Org Mode  |
;;  --------------

;; Set before org loads: this is the root for both org and org-roam.
(setq org-directory "~/docs")

(after! org
  (setq org-ellipsis " ▾"
        org-hide-emphasis-markers t))

;;  ---------------
;;  |  Org Roam   |
;;  ---------------

(setq org-roam-directory (file-truename "~/docs")
      org-roam-dailies-directory "journal/"
      org-roam-completion-everywhere t)

(after! org-roam
  (require 'org-roam-dailies)
  (load! "org-roam-templates")

  ;; Keep your familiar C-c n * bindings alongside Doom's own SPC n r *.
  (global-set-key (kbd "C-c n l") #'org-roam-buffer-toggle)
  (global-set-key (kbd "C-c n f") #'org-roam-node-find)
  (global-set-key (kbd "C-c n g") #'org-roam-graph)
  (global-set-key (kbd "C-c n i") #'org-roam-node-insert)
  (global-set-key (kbd "C-c n c") #'org-roam-capture)
  (define-key global-map (kbd "C-c n d") org-roam-dailies-map))

;;  ----------------------
;;  |  Writer Role       |
;;  ----------------------

;; prose.el is merged into the doomDir by Nix only when userSettings.role
;; includes "writer" (see ../default.nix and ../doom-writer/); NOERROR makes
;; this a no-op for everyone else.
(load! "prose" nil t)
