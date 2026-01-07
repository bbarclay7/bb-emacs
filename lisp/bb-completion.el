;;; package --- Summary
;;; bb-completion.el

;;; Commentary:
;; Completion configuration: auto-complete with custom dictionaries

;;; Code:

;;;; Auto-complete
(use-package auto-complete
  :ensure t
  :defer t
  :config
  (add-to-list 'ac-dictionary-directories (concat bb-emacslib-root "/ac-dict"))
  (require 'auto-complete-config)
  (ac-config-default))

(provide 'bb-completion)
;;; bb-completion.el ends here
