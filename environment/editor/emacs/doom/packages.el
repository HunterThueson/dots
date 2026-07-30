;; -*- no-byte-compile: t; -*-
;;; environment/editor/emacs/doom/packages.el

;;  Declare packages that Doom's enabled modules don't already provide. After
;;  editing this file, run a Nix rebuild (unstraightened reads it at build time)
;;  followed by `M-x doom/reload'.
;;
;;  Almost everything from the old hand-rolled config is now a Doom module:
;;    magit, evil-collection, which-key, projectile, rainbow-delimiters,
;;    ivy/counsel (→ vertico), helpful, general → all built in.

;; Shows the keys you press on-screen; handy while learning.
;;   M-x global-command-log-mode  then  M-x clm/toggle-command-log-buffer
(package! command-log-mode)
