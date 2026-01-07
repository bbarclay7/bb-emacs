;;; package --- Summary
;;; bb-navigation.el

;;; Commentary:
;; Navigation tools: tabbar, winum, projectile, org-mode

;;; Code:

;;;; Tabbar - buffer tabs
(use-package tabbar
  :ensure t)
(load "tabbar-config.el")
(global-set-key [S-left] 'tabbar-backward)
(global-set-key [S-right] 'tabbar-forward)
(global-set-key [S-up] 'tabbar-backward-group)
(global-set-key [S-down] 'tabbar-forward-group)
(tabbar-mode t)

;; Don't override shift-arrow; let tabbar have it
(setq org-replace-disputed-keys t)
(setq org-support-shift-select 'always)

;;;; Projectile - project management
(use-package projectile
  :ensure t
  :defer 1
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

;;;; Winum - window numbering
(use-package winum
  :ensure t
  :config
  (winum-mode))

;;;; Org-mode configuration
(setq org-agenda-deadline-leaders '("In %3d d.: "))
(setq org-agenda-include-diary t)

;; Org-mode keybindings
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

;;;; Org-modern styling
(use-package org-modern
  :ensure t
  :hook (org-mode . org-modern-mode)
  :defer t)

(provide 'bb-navigation)
;;; bb-navigation.el ends here
