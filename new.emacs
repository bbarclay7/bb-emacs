;; -*- coding: utf-8; mode: emacs-lisp -*-

;; enable file-local variables like coding and mode above
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Specifying-File-Variables.html
(setq enable-local-variables t)

;; set emacs lisp path

(defvar bb-emacslib-root
  (if (getenv "BB_EMACS")
      (getenv "BB_EMACS")
    "~/bb-emacs"))

(setq load-path
      (cons (expand-file-name bb-emacslib-root) load-path))
(setq user-emacs-directory bb-emacslib-root)

;; platform customization
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)


;; mepla setup
;; ref - https://melpa.org/partials/getting-started.html

(require 'package)
(setq package-user-dir (concat bb-emacslib-root "/melpa-packages"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)



;; color theme, font
;; linux - the following requires the file ~/.fonts/Inconsolata.otf
;; macos - install the font
(add-to-list 'default-frame-alist '(font . "Inconsolata 16"))

;; tabbar
 
;; autocomplete

;; paren matching

;; hide/show mode - Hideshow mode is a buffer-local minor mode that allows you to selectively display portions of a program, which are referred to as blocks
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Hideshow.html

;; set CRTL-= to hide/show current block.
(global-set-key (kbd "C-=")     'hs-toggle-hiding)

;; set set ALT-= to hide/show all blocks
(defvar hs-toggle-hideall-state nil)
(defun hs-toggle-hideall ()
  "Toggle collapse / expand all blocks"
  (interactive)
  (unless (bound-and-true-p hs-minor-mode)
    (hs-minor-mode))
  (if hs-toggle-hideall-state
      (progn
        (setq hs-toggle-hideall-state nil)
        (hs-show-all))
    (progn
      (setq hs-toggle-hideall-state t)
      (hs-hide-all))))
(global-set-key (kbd "M-=")     'hs-toggle-hideall)

;; autoload for some modes:
(add-hook 'lisp-mode-hook       'hs-minor-mode)
(add-hook 'scheme-mode-hook     'hs-minor-mode)
(add-hook 'c-mode-common-hook   'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'python-mode-hook     'hs-minor-mode)
(add-hook 'perl-mode-hook       'hs-minor-mode)
(add-hook 'sh-mode-hook         'hs-minor-mode)


;; decent defaults for command line


