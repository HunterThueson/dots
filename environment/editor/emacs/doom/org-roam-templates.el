;;; org-roam-templates.el --- Org-roam capture templates -*- lexical-binding: t; -*-

;;  ---------------------------------
;;  |  Org Roam Capture Templates   |
;;  ---------------------------------

(setq org-roam-capture-templates
      '(("d" "default" plain "%?"
         :if-new (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n#+filetags:\n")
         :unnarrowed t)

        ("r" "reference" plain "* Source: %^{Source|%A}\n\n* Notes: %?\n"
         :if-new (file+head "reference/${slug}.org"
                            "#+title: ${title}\n#+filetags: :reference:\n\n")
         :unnarrowed t)

        ("p" "project" plain "* Abstract: %?\n\n* Tasks: \n\n* Notes: \n"
         :if-new (file+head "projects/${slug}.org"
                            "#+title: ${title}\n#+filetags: :project:\n\n")
         :unnarrowed t)))

;;  ------------------------------------------
;;  |  Org Roam Dailies Capture Templates    |
;;  ------------------------------------------

;;  NOTE: the "event", "task" and "birthday" entries used to live outside this
;;  `setq' with unbalanced parens, so they never registered. They're now inside
;;  the list, and the TODO keywords are real org states (were "TODO:" literals).

(setq org-roam-dailies-capture-templates
      '(("d" "default" entry "* %<%H:%M>\n%?"
         :if-new (file+head "%<%Y-%m-%d>.org"
                            "#+title: %<%Y-%m-%d>\n"))

        ("a" "appointment" entry "* TODO %^{Title}\nSCHEDULED: %^T\nLOCATION: %^{Location}\n%?"
         :if-new (file+head "%<%Y-%m-%d>.org"
                            "#+title: %<%Y-%m-%d>\n#+filetags: :appointment:\n"))

        ("e" "event" entry "* EVENT: %^{Title}\nSCHEDULED: %^t\n%?"
         :if-new (file+head "%<%Y-%m-%d>.org"
                            "#+title: %<%Y-%m-%d>\n#+filetags: :event:\n"))

        ("t" "task" entry "* TODO %?\nSCHEDULED: %^T"
         :if-new (file+head "%<%Y-%m-%d>.org"
                            "#+title: %<%Y-%m-%d>\n"))

        ("b" "birthday" entry "* %^{Person}'s Birthday: %^{Birthday}t\n%?"
         :if-new (file+head "%<%Y-%m-%d>.org"
                            "#+title: %<%Y-%m-%d>\n#+filetags: :birthday:\n"))))
