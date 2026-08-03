;; -*- no-byte-compile: t; -*-
;;; environment/editor/emacs/doom-writer/packages.el

;;  Writer-role package additions. This file is APPENDED to doom/packages.el at
;;  build time (see ../default.nix) when userSettings.role includes "writer" —
;;  it is not a standalone packages.el. After editing, run a Nix rebuild.

;; Prose-writing extras (configured in prose.el)
(package! org-appear)        ; reveal hidden org emphasis markers at point
(package! powerthesaurus)    ; thesaurus lookup via powerthesaurus.org
(package! writegood-mode)    ; highlight weasel words, passive voice, duplicates
(package! page-break-lines)  ; render ^L page breaks as full-width rules [also a dashboard dep, pinned here for independence]
