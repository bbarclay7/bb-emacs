;; -*- coding: utf-8; mode: emacs-lisp -*-



;; enable file-local variables like coding and mode above
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Specifying-File-Variables.html
(setq enable-local-variables t)

;; set emacs lisp path

(defvar bb-emacslib-root (file-name-directory (file-truename user-init-file)))
  
(setq load-path
      (cons (concat bb-emacslib-root "/lisp") load-path))

(setq user-emacs-directory bb-emacslib-root)

(load "bblib.el")

;;(mapc #'byte-compile-el-file-lazy
;;      (cons (file-truename user-init-file)
;;       (directory-files bb-emacslib-root t "\\.el$")))

;; platform customization
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)


;; mepla setup
;; ref - https://melpa.org/partials/getting-started.html

(setq package-user-dir (concat bb-emacslib-root "/melpa-packages"))

(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)



;; color theme, font
;; linux - the following requires the file ~/.fonts/Inconsolata.otf
;; macos - install the font
(add-to-list 'default-frame-alist '(font . "Inconsolata 16"))

;; color theme
(when (display-graphic-p)
  (set-background-color "#102e4e")
  (set-foreground-color "#eeeeee")
  (set-face-background 'default "#102e4e")
  (set-face-foreground 'default "#eeeeee")
  (global-hl-line-mode)
  )


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

;;;;;;;;;;;;;;;
;; packages
;;;;;;;;;;;;;;;
;;https://emacs.stackexchange.com/questions/37904/how-do-i-work-out-what-the-problem-is-with-the-emacs-package-system/56067#56067
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(gnutls-algorithm-priority "normal:-vers-tls1.3")
 '(package-selected-packages
   '( yaml-mode flycheck-aspell flycheck editorconfig dash s-buffer x company use-package tabbar rainbow-delimiters nlinum auto-complete auto-compile)))

(require 'use-package)

;; flycheck mode -- https://www.flycheck.org/en/latest/user/installation.html#package-installation
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package auto-compile
  :ensure t)
(auto-compile-on-load-mode)
(auto-compile-on-save-mode)


;; https://stackoverflow.com/questions/1587972/how-to-display-indentation-guides-in-emacs/4459159#4459159
(defun aj-toggle-fold ()
  "Toggle fold all lines larger than indentation on current line"
  (interactive)
  (let ((col 1))
    (save-excursion
      (back-to-indentation)
      (setq col (+ 1 (current-column)))
      (set-selective-display
       (if selective-display nil (or col 1))))))
(global-set-key [(M C i)] 'aj-toggle-fold)
;(require 'highlight-indentation)
;(add-hook 'python-mode-hook 'highlight-indentation-mode)
;(add-hook 'js2-mode-hook 'highlight-indentation-mode)

;; (let ((font "Arial")
;;       (background "#CCC")
;;       (height 44))
;;    ;(elpy-enable)
;;    (set-face-background 'highlight-indentation-face background)
;;    (set-face-attribute 'highlight-indentation-face nil :height height)
;;    ;(set-face-attribute 'linum nil :height 1)
;;    ;(set-face-attribute 'linum nil :font font)
;;    )




(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))
(when (display-graphic-p)
  
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#102e4e" :foreground "#eeeeee" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 154 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(quack-pltish-defn-face ((t (:foreground "dark orange" :weight bold))))
 '(rainbow-delimiters-depth-1-face ((t (:foreground "red"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "yellow"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "lawn green"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "cyan"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "magenta"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "tomato"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "tan"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "cornsilk"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "medium sea green")))))
  )





(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#102e4e" :foreground "#eeeeee" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 154 :width normal :foundry "unknown" :family "DejaVu Sans Mono"))))
 '(quack-pltish-defn-face ((t (:foreground "dark orange" :weight bold))))
 '(rainbow-delimiters-depth-1-face ((t (:foreground "red"))))
 '(rainbow-delimiters-depth-2-face ((t (:foreground "yellow"))))
 '(rainbow-delimiters-depth-3-face ((t (:foreground "lawn green"))))
 '(rainbow-delimiters-depth-4-face ((t (:foreground "cyan"))))
 '(rainbow-delimiters-depth-5-face ((t (:foreground "magenta"))))
 '(rainbow-delimiters-depth-6-face ((t (:foreground "tomato"))))
 '(rainbow-delimiters-depth-7-face ((t (:foreground "tan"))))
 '(rainbow-delimiters-depth-8-face ((t (:foreground "cornsilk"))))
 '(rainbow-delimiters-depth-9-face ((t (:foreground "medium sea green")))))


;;;; copilot
(when (not (getenv "EC_SITE"))
  (use-package copilot
    :load-path (lambda () (expand-file-name "copilot.el" user-emacs-directory))
    ;; don't show in mode line
    :diminish)
  
  (load "bb-copilot.el"))





;;;; tabbar
(use-package tabbar
  :ensure t
)
(load "tabbar-config.el")
(global-set-key [S-left] 'tabbar-backward)
(global-set-key [S-right] 'tabbar-forward)
(global-set-key [S-up] 'tabbar-backward-group)
(global-set-key [S-down] 'tabbar-forward-group)
(tabbar-mode t)

;;;; autocomplete
(use-package company
  :ensure t)

;; (add-hook 'company-mode-hook
;; 	  '(lambda ()
;;              (add-to-list 'company-backends 'company-dabbrev-code)
;;              ))



;; (add-hook 'after-init-hook 'global-company-mode)


(use-package auto-complete
  :ensure t
)
(add-to-list 'ac-dictionary-directories (concat bb-emacslib-root "/ac-dict"))
(require 'auto-complete-config)
(ac-config-default)



;;;; line numbering
(use-package nlinum  :ensure t )
(global-set-key [f9] 'nlinum-mode)


;;;; misc. shortcuts

;; http://edivad.wordpress.com/2007/05/31/emacs-reload-a-file/
(defun my-revert-buffer ()
  "revert buffer without asking for confirmation"
  (interactive) 
  (revert-buffer t t)
  )
(global-set-key [f5] 'my-revert-buffer)


;;;; misc. behaviors

(global-set-key "\C-x55" 'split-window-fork)
(global-set-key "\C-x\C-c" 'intelligent-close) 

;; Tell emacs to save backups in the global backups directory...
(setq
 backup-by-copying t      ; No usar links simbolicos
 backup-directory-alist
 '(("." . "~/.saves"))   ; Guardamos en .saves/
 delete-old-versions t
 kept-new-versions 6
 kept-old-versions 2
 version-control t)       ; Y les ponemos numeritos a todos los cambios (como lo hace el CVS)


;; show full path to file being edited in frame -- https://emacs.stackexchange.com/questions/33388/show-the-full-path-to-the-file
(setq-default frame-title-format "%b (%f)")

;; Everything in UTF-8
(prefer-coding-system 'utf-8)
(set-language-environment 'UTF-8)
(set-default-coding-systems             'utf-8)
(setq file-name-coding-system           'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(setq coding-system-for-write           'utf-8)
(set-keyboard-coding-system             'utf-8)
(set-terminal-coding-system             'utf-8)
(set-clipboard-coding-system            'utf-8)
(set-selection-coding-system            'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))


;; don't override shift-arrow; let tabbar have it
(setq org-replace-disputed-keys t)

;; don't prompt for following symlinks into git workspaces
(setq vc-follow-symlinks t)

(setq inhibit-startup-screen t)

(tool-bar-mode -1)

;; https://www.emacswiki.org/emacs/CopyAndPaste
(setq x-select-enable-primary t)

;; useful for calendar-sunrise-sunset
(setq calendar-latitude 38.6722)
(setq calendar-longitude -121.1578)
(setq calendar-location-name "Folsom,CA USA")

;; f8 kill buffer
(global-set-key [f8] 'my-kill-buffer)
(global-set-key [S-f8] 'my-unkill-buffer)

;; show paren, brace, and curly brace "partners" at all times
(show-paren-mode t)
;; jump to matching paren when you press '%' key 
(global-set-key "%" 'match-paren)
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

;; highlight changes in documents
(global-highlight-changes-mode t)
(setq highlight-changes-visibility-initial-state nil); initially hide
(set-face-foreground 'highlight-changes nil)
(set-face-background 'highlight-changes "#382f2f")
(set-face-foreground 'highlight-changes-delete nil)
(set-face-background 'highlight-changes-delete "#916868")
;; alt-pgup/pgdown jump to the previous/next change
(global-set-key (kbd "<M-prior>") 'highlight-changes-next-change)  ;; alt-pageup
(global-set-key (kbd "<M-next>")  'highlight-changes-previous-change)  ;; alt-pagedn

; f6 doc changes visibility
(global-set-key (kbd "<f6>")      'highlight-changes-visible-mode) ;; changes
;; remove the change-highlight in region
(global-set-key (kbd "S-<f6>")    'highlight-changes-remove-highlight)

; full screen - alt f11
(global-set-key [M-f11] 'x11-maximize-frame)


;; use scroll mouse
(defun up-slightly () (interactive) (scroll-up 5))
(defun down-slightly () (interactive) (scroll-down 5))
(defun up-one () (interactive) (scroll-up 1))
(defun down-one () (interactive) (scroll-down 1))
(defun up-a-lot () (interactive) (scroll-up))
(defun down-a-lot () (interactive) (scroll-down))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)
(global-set-key [S-mouse-4] 'down-one)
(global-set-key [S-mouse-5] 'up-one)
(global-set-key [C-mouse-4] 'down-a-lot)
(global-set-key [C-mouse-5] 'up-a-lot)
;;  S-tab -> complettion at point
;;  C-/ -> undo


(global-set-key "\M-g" 'goto-line)
(global-set-key "\M-d" 'insert-date)

(global-set-key (kbd "M-s C-s") 'isearch-forward-symbol-at-point)


					;(defun bb-tabbar-bindings ()
(setq org-support-shift-select 'always)
  (global-set-key [S-left] 'tabbar-backward)
  (global-set-key [S-right] 'tabbar-forward)
  (global-set-key [S-up] 'tabbar-backward-group)
  (global-set-key [S-down] 'tabbar-forward-group)
  ;;(global-set-key [backtab] 'tabbar-mode)
;  )
;;

(fido-mode)


;; auto chmod +x files with shebang line
(require 'shebang)

;; show col num
(setq column-number-mode t)

;; load facts from John McCarthy -- https://news.ycombinator.com/item?id=37420812
(load "facts.el")
