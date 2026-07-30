;;; init.el -*- lexical-binding: t; -*-

;; environment/editor/emacs/doom/init.el
;;
;;  /-----------------------\
;; >  Doom Emacs — Modules   <
;;  \-----------------------/
;;
;;  This file only toggles Doom modules on/off. Personal configuration lives in
;;  config.el, and extra packages (beyond what a module pulls in) in packages.el.
;;  nix-doom-emacs-unstraightened reads THIS file at build time to decide which
;;  Emacs packages to build, so a rebuild is needed after changing it.
;;
;;  Run `M-x doom/help-modules` (or read the docstrings) to learn what each flag
;;  does. Flags marked +foo enable optional features of a module.

(doom! :input

       :completion
       (vertico +icons)           ; the search engine of the future  [swap for `ivy` if you miss swiper/counsel]
       (company +childframe)      ; the ultimate code completion backend

       :ui
       doom                       ; what makes DOOM look the way it does
       dashboard                  ; a nifty splash screen for Emacs
       hl-todo                    ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
       (ligatures)                ; ligatures and symbols to make code pretty again
       modeline                   ; snazzy, Atom-inspired modeline
       ophints                    ; highlight the region an operation acts on
       (popup +defaults)          ; tame sudden yet inevitable temporary windows
       vc-gutter                  ; vcs diff in the fringe
       vi-tilde-fringe            ; fringe tildes to mark beyond EOB (vim-like)
       (window-select +numbers)   ; visually switch windows
       workspaces                 ; tab emulation, persistence & separate workspaces
       zen                        ; distraction-free coding or writing

       :editor
       (evil +everywhere)         ; come to the dark side, we have cookies
       file-templates             ; auto-snippets for empty files
       fold                       ; (nigh) universal code folding
       (format +onsave)           ; automated prettiness
       snippets                   ; my elves. They type so I don't have to
       word-wrap                  ; soft wrapping with language-aware indent

       :emacs
       (dired +icons)             ; making dired pretty [functional]
       electric                   ; smarter, keyword-based electric-indent
       (ibuffer +icons)           ; interactive buffer management
       undo                       ; persistent, smarter undo for your inevitable mistakes
       vc                         ; version-control and Emacs, sitting in a tree

       :term
       vterm                      ; the best terminal emulation in Emacs

       :checkers
       syntax                     ; tasing you for every semicolon you forget
       (spell +flyspell)          ; tasing you for misspelling mispelling

       :tools
       direnv                     ; be direct about your environment (nix-shell/flakes)
       (lookup +docsets)          ; navigate your code and its documentation
       magit                      ; a git porcelain for Emacs
       tree-sitter                ; syntax and parsing, sitting in a tree...

       :lang
       emacs-lisp                 ; drown in parentheses
       (json)                     ; At least it ain't XML
       (markdown)                 ; writing docs for people to ignore
       (nix)                      ; I hereby declare "nix geht mehr!"
       (org +roam2)               ; organize your plain life in plain text
       (python)                   ; beautiful is better than ugly
       (rust)                     ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
       (sh)                       ; she sells {ba,z,fi}sh shells on the C xor
       (yaml)                     ; JSON, but readable

       :config
       (default +bindings +smartparens))
