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
;; Note: C-c a is reserved as prefix for AI commands
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c o a") #'org-agenda)  ; Changed from C-c a to avoid AI prefix conflict
(global-set-key (kbd "C-c c") #'org-capture)

;;;; Org-modern styling
(use-package org-modern
  :ensure t
  :hook (org-mode . org-modern-mode)
  :defer t)

;;;; Org-babel - execute code blocks in org files
;; Enable execution of bash/shell, elisp, and python code blocks
(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (shell . t)      ; bash, sh - for executing shell commands
   (python . t)))   ; python code blocks

;; Don't ask for confirmation before executing code blocks
;; (Security: only enable this for trusted org files)
(setq org-confirm-babel-evaluate nil)

;;;; Org-download - paste screenshots and images into org files
(use-package org-download
  :ensure t
  :after org
  :config
  ;; Save images in ./images/ subdirectory relative to org file
  (setq org-download-method 'directory
        org-download-image-dir "./images"
        org-download-heading-lvl nil  ; Don't organize by heading
        org-download-timestamp "%Y%m%d-%H%M%S_"  ; Timestamp format
        org-download-screenshot-method "screencapture -i %s")  ; macOS screenshot

  ;; Scale factor for image widths - 0.5 for Retina/HiDPI displays
  (defvar bb-org/image-scale-factor
    (if (eq system-type 'darwin) 0.5 1.0)
    "Scale factor for image widths. 0.5 for macOS Retina displays, 1.0 for others.")

  ;; Smart image width calculation based on buffer width
  (defun bb-org/smart-image-width ()
    "Calculate appropriate image width based on buffer width.
Returns width in pixels, capping at buffer width minus indentation.
Uses actual frame-char-width for accurate HiDPI/Retina display handling."
    (let* ((window-width (window-body-width))  ; Width in characters
           (char-width (frame-char-width))      ; Actual pixels per character
           (indent (save-excursion
                     (beginning-of-line)
                     (skip-chars-forward " \t")
                     (current-column)))
           (usable-chars (- window-width indent 2))  ; Leave 2 char margin
           (max-width (* usable-chars char-width bb-org/image-scale-factor)))  ; Convert to pixels
      (max 400 (min max-width 1200))))  ; Min 400px, max 1200px

  ;; Use annotate function to add width attribute dynamically
  (setq org-download-annotate-function
        (lambda (_link)
          (format "#+ATTR_ORG: :width %d\n" (bb-org/smart-image-width))))

  ;; Clear the old image-attr-list to avoid conflicts
  (setq org-download-image-attr-list nil)

  ;; Keybindings for org-mode - use C-c i prefix (i for image)
  ;; Use org-mode-hook to ensure keybindings work in all org buffers
  (add-hook 'org-mode-hook
            (lambda ()
              (local-set-key (kbd "C-c i p") 'org-download-clipboard)
              (local-set-key (kbd "C-c i s") 'org-download-screenshot))))

;; Helper function to resize image at point
(defun bb-org/resize-image-at-point (width)
  "Resize the image at point to WIDTH pixels.
If called interactively, prompt for width."
  (interactive "nImage width (pixels): ")
  (save-excursion
    (let ((context (org-element-context)))
      (when (eq (org-element-type context) 'link)
        (goto-char (org-element-property :begin context))
        ;; Remove existing ATTR_ORG if present
        (when (save-excursion
                (forward-line -1)
                (looking-at "^[ \t]*#\\+ATTR_ORG:"))
          (forward-line -1)
          (kill-line 1))
        ;; Insert new ATTR_ORG
        (beginning-of-line)
        (insert (format "#+ATTR_ORG: :width %d\n" width))
        (message "Image resized to %d pixels" width)))))

(global-set-key (kbd "C-c i w") 'bb-org/resize-image-at-point)

(provide 'bb-navigation)
;;; bb-navigation.el ends here
