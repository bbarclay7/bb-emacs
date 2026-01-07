;; -*- Coding: utf-8; mode: emacs-lisp -*-
;;; package --- Summary

;;; .emacs

;;; Commentary:
;;This file configures Emacs runtime for Brandon Barclay.
;;Modular configuration - core functionality split into /lisp modules.

;;; Code:
;; enable file-local variables like coding and mode above
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Specifying-File-Variables.html
(setq enable-local-variables t)

;; set emacs lisp path
(defvar bb-emacslib-root (file-name-directory (file-truename user-init-file)))

(setq load-path
      (cons (concat bb-emacslib-root "/lisp") load-path))

(setq user-emacs-directory bb-emacslib-root)

;; Load core utilities first
(load "bblib.el")

;; platform customization
(when (eq system-type 'darwin)
  (setq mac-option-modifier 'super)
  (setq mac-command-modifier 'meta))

;; MELPA setup
;; ref - https://melpa.org/partials/getting-started.html
(setq package-user-dir (concat bb-emacslib-root "/melpa-packages"))

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Package configuration
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(gnutls-algorithm-priority "normal:-vers-tls1.3")
 '(org-agenda-files '("/Users/bb/agenda/premiers.org"))
 '(package-selected-packages
   '(projectile winum p4 openwith org-download org-modern markdown-preview-mode gptel markdown-mode yaml-mode flycheck-aspell flycheck editorconfig dash s-buffer x use-package tabbar rainbow-delimiters nlinum auto-complete auto-compile)))

(require 'use-package)

;; Custom faces (for display-graphic-p contexts)
(when (display-graphic-p)
  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   '(default ((t (:inherit nil :stipple nil :background "#102e4e" :foreground "#eeeeee" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 154 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
   '(quack-pltish-defn-face ((t (:foreground "dark orange" :weight bold))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load modular configuration files
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Core settings (theme, encoding, basic behavior)
(load "bb-core.el")

;; Keybindings and interactive functions
(load "bb-keybindings.el")

;; Coding tools (flycheck, editorconfig, rainbow-delimiters, etc.)
(load "bb-coding.el")

;; Completion framework
(load "bb-completion.el")

;; Navigation (tabbar, projectile, winum, org-mode)
(load "bb-navigation.el")

;; AI assistance (copilot, gptel, Claude Code hooks)
(load "bb-ai.el")

(provide 'dot)
;;; dot.emacs ends here
