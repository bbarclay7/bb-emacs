;;; package --- Summary
;;; bb-core.el

;;; Commentary:
;; Core Emacs settings: theme, encoding, basic behavior, frame management

;;; Code:

;; Color theme and font
(add-to-list 'default-frame-alist '(font . "Inconsolata 16"))

(when (display-graphic-p)
  (set-background-color "#102e4e")
  (set-foreground-color "#eeeeee")
  (set-face-background 'default "#102e4e")
  (set-face-foreground 'default "#eeeeee")
  (global-hl-line-mode))

;; UTF-8 everywhere
(prefer-coding-system 'utf-8)
(set-language-environment 'UTF-8)
(set-default-coding-systems 'utf-8)
(setq file-name-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(setq coding-system-for-write 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))

;; Basic UI settings
(setq inhibit-startup-screen t)
(tool-bar-mode -1)
(show-paren-mode t)
(column-number-mode t)
(setq x-select-enable-primary t)

;; Frame title - show full path
(setq-default frame-title-format "%b (%f)")

;; Backup settings
(setq backup-by-copying t
      backup-directory-alist '(("." . "~/.saves"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; Version control
(setq vc-follow-symlinks t)

;; Calendar location (for sunrise/sunset)
(setq calendar-latitude 38.6722
      calendar-longitude -121.1578
      calendar-location-name "Folsom,CA USA")

;; Fido mode for minibuffer completion
(fido-mode)

;; Change highlighting
(global-highlight-changes-mode t)
(setq highlight-changes-visibility-initial-state nil)
(set-face-foreground 'highlight-changes nil)
(set-face-background 'highlight-changes "#382f2f")
(set-face-foreground 'highlight-changes-delete nil)
(set-face-background 'highlight-changes-delete "#916868")

(provide 'bb-core)
;;; bb-core.el ends here
