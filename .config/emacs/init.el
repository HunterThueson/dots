
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

;; Enable projectile
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~")
    (setq projectile-project-search-path '("~")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

;; Enable magit
(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;;--------------------;;
;;  Theme Management  ;;
;;--------------------;;

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic t)
  :init (load-theme 'doom-vibrant t))     ; This is where you change the theme

;;------------------------;;
;;  General Key Bindings  ;;
;;------------------------;;

(use-package general
  :config
  (general-create-definer buns/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (buns/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(general-define-key
  "C-M-j" 'counsel-switch-buffer)           ;; Switch buffers w/ `Ctrl+Alt+j`

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(buns/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text"))

;;-------------;;
;;  Evil Mode  ;;
;;-------------;;

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;;  --------------
;;  |  Org Mode  |
;;  --------------

(use-package org)
