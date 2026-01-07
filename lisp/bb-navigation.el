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

;; CRITICAL: Make Org-mode respect #+ATTR_ORG :width for inline images
;; nil = always use #+ATTR width, don't use actual image dimensions
(setq org-image-actual-width nil)

;; Auto-display inline images when opening org files
(setq org-startup-with-inline-images t)

;; Fix scrolling past tall images - prevent cursor from snapping back
(setq scroll-conservatively 101)  ; Never recenter when scrolling
(setq scroll-margin 0)             ; No scroll margin
(setq scroll-preserve-screen-position t)  ; Keep cursor position when scrolling

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
  ;; Create images directory in same folder as the org file
  (defun bb-org/download-image-dir ()
    "Return path to images directory, creating it if needed."
    (let* ((org-file-dir (file-name-directory (buffer-file-name)))
           (images-dir (expand-file-name "images" org-file-dir)))
      (unless (file-exists-p images-dir)
        (make-directory images-dir t))
      images-dir))

  (setq org-download-method 'directory
        org-download-image-dir 'bb-org/download-image-dir  ; Use function to ensure dir exists
        org-download-heading-lvl nil  ; Don't organize by heading
        org-download-timestamp "%Y%m%d-%H%M%S_"  ; Timestamp format
        org-download-screenshot-method "screencapture -i %s")  ; macOS screenshot

  ;; Smart image width calculation based on buffer width
  (defun bb-org/smart-image-width ()
    "Calculate appropriate image width based on buffer width.
Multiplies usable character width by pixels-per-char for proper sizing."
    (let* ((window-width (window-body-width))
           (indent (save-excursion
                     (beginning-of-line)
                     (skip-chars-forward " \t")
                     (current-column)))
           (usable-chars (- window-width indent 2))
           (pixels-per-char (if (eq system-type 'darwin) 6 8))  ; 6 for Retina, 8 for others
           (calculated-width (* usable-chars pixels-per-char))
           (final-width (max 300 (min calculated-width 1000))))  ; Min 300px, max 1000px
      (message "Image width calc: win=%d indent=%d usable=%d × %dpx/char → %dpx"
               window-width indent usable-chars pixels-per-char final-width)
      final-width))

  ;; Use annotate function to add width attribute dynamically
  (setq org-download-annotate-function
        (lambda (_link)
          (format "#+ATTR_ORG: :width %d\n" (bb-org/smart-image-width))))

  ;; Clear the old image-attr-list to avoid conflicts
  (setq org-download-image-attr-list nil)

  ;; Auto-refresh inline images after pasting to apply width attribute
  (defun bb-org/refresh-images-after-paste (&rest _args)
    "Refresh inline images in org buffer after pasting."
    (when (derived-mode-p 'org-mode)
      (org-display-inline-images)))

  (advice-add 'org-download-clipboard :after #'bb-org/refresh-images-after-paste)
  (advice-add 'org-download-screenshot :after #'bb-org/refresh-images-after-paste)

  ;; Keybindings for org-mode - use C-c i prefix (i for image)
  ;; Use org-mode-hook to ensure keybindings work in all org buffers
  (add-hook 'org-mode-hook
            (lambda ()
              (local-set-key (kbd "C-c i p") 'org-download-clipboard)
              (local-set-key (kbd "C-c i s") 'org-download-screenshot)
              (local-set-key (kbd "C-c i t") 'org-toggle-inline-images))))

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
