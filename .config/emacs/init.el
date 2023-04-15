;; ~/.config/emacs/init.el
;;
;;  /---------------------\
;; >  Emacs Configuration  <
;;  \---------------------/
;;
;;  Note: in its current state, this configuration is copied nearly verbatim
;;  from "System Crafters" on YouTube -- I am following the "Emacs From Scratch
;;  #1 - Getting Started with a Basic Usable Configuration" video tutorial in
;;  order to get up and running with Emacs as quickly as possible. This will be
;;  further customized by me at a later date.
;;
;;  (That being said, I do take credit for the fancy comment formatting ;)

;;  ---------------------------
;;  |  Basic Quality of Life  |
;;  ---------------------------

(setq inhibit-startup-message t)    ; Disable startup message
(setq visible-bell nil)             ; Disable visual bell

(scroll-bar-mode -1)                ; Disable visible scrollbar
(tool-bar-mode -1)                  ; Disable the toolbar
(tooltip-mode -1)                   ; Disable tooltips
(set-fringe-mode ( . 0))            ; Set margins
(menu-bar-mode -1)                  ; Disable the menubar

;;  -------------------------
;;  |  Appearance Settings  |
;;  -------------------------

;; Set font
(set-face-attribute 'default nil :font "Fira Code Nerd Font" :height 92)

;;  Enable line numbers
(require 'display-line-numbers)

;; Don't resize number column when scrolling
(setq display-line-numbers-width-start t)

;; Use relative visual line numbers
(setq display-line-numbers-type 'visual)
(setq display-line-numbers-current-absolute 1)

(defcustom display-line-numbers-exempt-modes
  '(vterm-mode eshell-mode shell-mode term-mode ansi-term-mode)
  "Major modes on which to disable line numbers."
  :group 'display-line-numbers
  :type 'list
  :version "green")

(defun display-line-numbers--turn-on ()
  "Turn on line numbers except for certain major modes.
Exempt major modes are defined in `display-line-numbers-exempt-modes'."
  (unless (or (minibufferp)
              (member major-mode display-line-numbers-exempt-modes))
    (display-line-numbers-mode)))

(global-display-line-numbers-mode)

;; Enable column number indicator
(column-number-mode)

;;  ------------------------
;;  |  Package Management  |
;;  ------------------------

(require 'package)                  ; Enable package management functions

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Enable keyboard command logging (shows what keys you're pressing on screen)
(use-package command-log-mode)
;; Usage:
;;    `M-x clm/toggle-command-log-buffer`
;;    `M-x global-command-log-mode`

;; Enable rainbow delimiters
(use-package rainbow-delimiters
    :hook (prog-mode . rainbow-delimiters-mode))

;; Enable which-key to show available commands upon using a keybind
(use-package which-key
    :init (which-key-mode)
    :diminish which-key-mode
    :config
    (setq which-key-idle-delay 0.05))

; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Ivy
(use-package ivy
    :diminish
    :bind (("C-s" . swiper)
           :map ivy-minibuffer-map
           ("TAB" . ivy-alt-done)
           ("C-l" . ivy-alt-done)
           ("C-j" . ivy-next-line)
           ("C-k" . ivy-previous-line)
           :map ivy-switch-buffer-map
           ("C-k" . ivy-previous-line)
           ("C-l" . ivy-done)
           ("C-d" . ivy-switch-buffer-kill)
           :map ivy-reverse-i-search-map
           ("C-k" . ivy-previous-line)
           ("C-d" . ivy-reverse-i-search-kill))
    :config
    (ivy-mode 1))

;; Counsel
(use-package counsel
    :bind (("M-x" . counsel-M-x)
           ("C-x b" . counsel-ibuffer)
           ("C-x C-f" . counsel-find-file)
           :map minibuffer-local-map
           ("C-r" . 'counsel-minibuffer-history))
    :config
    (setq ivy-initial-inputs-alist nil))    ;; Don't start searches with ^

;; Enable ivy-rich
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;; Enable helpful
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;;--------------------;;
;;  Theme Management  ;;
;;--------------------;;

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic t)
  :init (load-theme 'doom-vibrant t))     ; This is where you change the theme

