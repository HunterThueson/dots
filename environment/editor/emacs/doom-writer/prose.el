;;; prose.el -*- lexical-binding: t; -*-

;; environment/editor/emacs/doom-writer/prose.el
;;
;;  /--------------------------\
;; >  Doom Emacs — Prose Mode   <
;;  \--------------------------/
;;
;;  Writer-role configuration for long-form prose (fiction, worldbuilding).
;;  Only merged into the doomDir when userSettings.role includes "writer";
;;  config.el `load!`s it with NOERROR, so other users never see it.
;;
;;  The core workflow: open any org/markdown buffer and hit `SPC t z` (zen).
;;  writeroom-mode centers a narrow column and hides the frame chrome, and
;;  mixed-pitch swaps body text to the serif font below while keeping code
;;  blocks, tables, and metadata monospace — so a manuscript .org file reads
;;  like a page, and your org-roam notes stay one `SPC n r f` away.

;;  ---------------------------
;;  |  Typography & Layout    |
;;  ---------------------------

;; Serif book face used wherever variable-pitch is active (zen's mixed-pitch,
;; or `M-x mixed-pitch-mode' directly). Literata is installed by ../default.nix
;; for writer-role users. Sized slightly above doom-font: serifs read smaller.
(setq doom-variable-pitch-font (font-spec :family "Literata" :size 16))

;; Column width of the centered writeroom text. Measured in monospace columns,
;; so proportional text lands near the ~70-char line books use.
(after! writeroom-mode
  (setq writeroom-width 90))

;; Line numbers are for code; drop them in the writing view, restore on exit.
(add-hook 'writeroom-mode-enable-hook (lambda () (display-line-numbers-mode -1)))
(add-hook 'writeroom-mode-disable-hook (lambda () (display-line-numbers-mode +1)))

;; Manuscript page breaks: insert a form feed with `C-q C-l' (evil: `i C-q C-l')
;; and it renders as a full-width horizontal rule instead of ^L.
(add-hook 'text-mode-hook #'page-break-lines-mode)

;;  --------------------
;;  |  Prose Tooling   |
;;  --------------------

;; Live word count in the modeline for prose buffers.
(setq doom-modeline-enable-word-count t
      doom-modeline-continuous-word-count-modes '(markdown-mode gfm-mode org-mode text-mode))

;; Emphasis markers stay hidden (org-hide-emphasis-markers in config.el) but
;; reappear while point is inside them, so *bold* is editable without guessing.
(add-hook 'org-mode-hook #'org-appear-mode)

;; Thesaurus lookup for the word at point (needs network; powerthesaurus.org).
(map! :leader :desc "Thesaurus" "s T" #'powerthesaurus-lookup-dwim)

;; `M-x writegood-mode' (per-buffer, on demand): flags weasel words, passive
;; voice, and accidental word duplication — useful on revision passes, noisy
;; while drafting, hence no hook.
