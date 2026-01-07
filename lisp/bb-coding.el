;;; package --- Summary
;;; bb-coding.el

;;; Commentary:
;; Coding-related configuration: syntax checking, formatting, code folding

;;; Code:

;;;; Flycheck - syntax checking
(use-package flycheck
  :ensure t
  :defer 2
  :init (global-flycheck-mode))

;;;; EditorConfig - consistent coding styles
(use-package editorconfig
  :ensure t
  :defer t
  :config
  (editorconfig-mode 1))

;;;; Rainbow delimiters
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(when (display-graphic-p)
  (custom-set-faces
   '(rainbow-delimiters-depth-1-face ((t (:foreground "red"))))
   '(rainbow-delimiters-depth-2-face ((t (:foreground "yellow"))))
   '(rainbow-delimiters-depth-3-face ((t (:foreground "lawn green"))))
   '(rainbow-delimiters-depth-4-face ((t (:foreground "cyan"))))
   '(rainbow-delimiters-depth-5-face ((t (:foreground "magenta"))))
   '(rainbow-delimiters-depth-6-face ((t (:foreground "tomato"))))
   '(rainbow-delimiters-depth-7-face ((t (:foreground "tan"))))
   '(rainbow-delimiters-depth-8-face ((t (:foreground "cornsilk"))))
   '(rainbow-delimiters-depth-9-face ((t (:foreground "medium sea green"))))))

;;;; Auto-compile
(use-package auto-compile
  :ensure t)
(auto-compile-on-load-mode)
;; Removed auto-compile-on-save-mode for faster editing (no lag on save)

;;;; Mode hooks for code folding
(add-hook 'lisp-mode-hook 'hs-minor-mode)
(add-hook 'scheme-mode-hook 'hs-minor-mode)
(add-hook 'c-mode-common-hook 'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'python-mode-hook 'hs-minor-mode)
(add-hook 'perl-mode-hook 'hs-minor-mode)
(add-hook 'sh-mode-hook 'hs-minor-mode)

;;;; Shebang auto-chmod
(require 'shebang)

;;;; John McCarthy's facts library
(load "facts.el")

(provide 'bb-coding)
;;; bb-coding.el ends here
