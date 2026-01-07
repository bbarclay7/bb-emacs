;;; package --- Summary
;;; bb-keybindings.el

;;; Commentary:
;; Global keybindings and custom interactive functions

;;; Code:

;; Function keys
(global-set-key [f5] 'my-revert-buffer)
(global-set-key [f6] 'highlight-changes-visible-mode)
(global-set-key [S-f6] 'highlight-changes-remove-highlight)
(global-set-key [f8] 'my-kill-buffer)
(global-set-key [S-f8] 'my-unkill-buffer)
(global-set-key [f9] 'display-line-numbers-mode)
(global-set-key [M-f11] 'x11-maximize-frame)

;; Navigation
(global-set-key "\M-g" 'goto-line)
(global-set-key "\M-d" 'insert-date)
(global-set-key (kbd "M-s C-s") 'isearch-forward-symbol-at-point)

;; Change navigation
(global-set-key (kbd "<M-prior>") 'highlight-changes-next-change)
(global-set-key (kbd "<M-next>") 'highlight-changes-previous-change)

;; Paren matching
(global-set-key "%" 'match-paren)
(defun match-paren (arg)
  "Go to the matching paren of ARG if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))

;; Window/frame management
(global-set-key "\C-x55" 'split-window-fork)
(global-set-key "\C-x\C-c" 'intelligent-close)

;; Code folding
(global-set-key (kbd "C-=") 'hs-toggle-hiding)
(global-set-key (kbd "M-=") 'hs-toggle-hideall)
(global-set-key [(M C i)] 'aj-toggle-fold)

;; Hide/show all toggle
(defvar hs-toggle-hideall-state nil)
(defun hs-toggle-hideall ()
  "Toggle collapse / expand all blocks."
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

;; Indentation-based folding
(defun aj-toggle-fold ()
  "Toggle fold all lines larger than indentation on current line."
  (interactive)
  (let ((col 1))
    (save-excursion
      (back-to-indentation)
      (setq col (+ 1 (current-column)))
      (set-selective-display
       (if selective-display nil (or col 1))))))

;; Buffer revert without confirmation
(defun my-revert-buffer ()
  "Revert buffer without asking for confirmation."
  (interactive)
  (revert-buffer t t))

;; Mouse scrolling
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

(provide 'bb-keybindings)
;;; bb-keybindings.el ends here
