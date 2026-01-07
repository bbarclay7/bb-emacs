;;; package --- Summary
;;; bb-ai.el

;;; Commentary:
;; AI-assisted development: gptel (LLM) and Claude Code integration hooks
;; 100% local AI with Ollama + Qwen3-Coder for privacy and offline capability

;;; Code:

;; Load our custom Ollama integration (more reliable than gptel)
(load "bb-ollama.el")

;;;; gptel - LLM integration (optional fallback)
;; gptel has buffer management issues with Ollama
;; Using bb-ollama.el for primary integration
;; (require 'gptel nil t)
;; (use-package gptel
;;   :ensure t
;;   :defer t
;;   :config (load "bb-gptel.el"))

;;;; Claude Code workflow hooks
;; These hooks integrate with Claude Code development workflows

;; Auto-save before running commands (prevents uncommitted changes warnings)
(defun bb-ai/auto-save-buffer-maybe ()
  "Automatically save current buffer if modified and visiting a file."
  (when (and (buffer-modified-p)
             (buffer-file-name))
    (save-buffer)))

;; Pre-command hook for AI-assisted operations
(defvar bb-ai/pre-command-hook nil
  "Hook run before AI-assisted commands.
Useful for Claude Code integration.")

;; Post-command hook for AI-assisted operations
(defvar bb-ai/post-command-hook nil
  "Hook run after AI-assisted commands.
Useful for Claude Code integration.")

;; Smart context gathering for AI assistants
(defun bb-ai/gather-context ()
  "Gather context about current buffer for AI assistants.
Returns an alist with buffer information."
  (list
   (cons 'file (or (buffer-file-name) "unsaved buffer"))
   (cons 'mode major-mode)
   (cons 'point (point))
   (cons 'region (when (use-region-p)
                   (buffer-substring-no-properties (region-beginning) (region-end))))
   (cons 'project (when (fboundp 'projectile-project-root)
                    (ignore-errors (projectile-project-root))))))

;; Function to send context to Ollama with smart defaults
(defun bb-ai/send-to-llm-with-context (prompt)
  "Send PROMPT to Ollama LLM with automatic context gathering."
  (interactive "sPrompt: ")
  (let* ((context (bb-ai/gather-context))
         (region (cdr (assoc 'region context))))
    (bb-ollama-query prompt region)))

;; F7 is already bound in bb-ollama.el to bb-ollama-query
;; which is simpler and more direct

;; Hook for when entering programming modes
(defun bb-ai/prog-mode-setup ()
  "Setup AI assistance for programming modes."
  (run-hooks 'bb-ai/pre-command-hook))

(add-hook 'prog-mode-hook 'bb-ai/prog-mode-setup)

;; Integration with project workflows
(defun bb-ai/project-context-string ()
  "Generate a project context string for AI assistants."
  (when (fboundp 'projectile-project-root)
    (let ((root (ignore-errors (projectile-project-root))))
      (when root
        (format "Project: %s\nProject type: %s"
                (file-name-nondirectory (directory-file-name root))
                (or (ignore-errors (projectile-project-type)) "unknown"))))))

;; Helper to explain current code to LLM
(defun bb-ai/explain-code ()
  "Send current region or function to LLM for explanation."
  (interactive)
  (let ((code (if (use-region-p)
                  (buffer-substring-no-properties (region-beginning) (region-end))
                (thing-at-point 'defun t))))
    (if code
        (bb-ai/send-to-llm-with-context
         (format "Please explain this code:\n```\n%s\n```" code))
      (message "No code region or function found"))))

;; Helper to generate tests
(defun bb-ai/generate-tests ()
  "Generate tests for current function or region."
  (interactive)
  (let ((code (if (use-region-p)
                  (buffer-substring-no-properties (region-beginning) (region-end))
                (thing-at-point 'defun t))))
    (if code
        (bb-ai/send-to-llm-with-context
         (format "Generate comprehensive tests for this code:\n```\n%s\n```" code))
      (message "No code region or function found"))))

;; Helper to refactor code
(defun bb-ai/refactor-code (instruction)
  "Refactor current region or function according to INSTRUCTION."
  (interactive "sRefactoring instruction: ")
  (let ((code (if (use-region-p)
                  (buffer-substring-no-properties (region-beginning) (region-end))
                (thing-at-point 'defun t))))
    (if code
        (bb-ai/send-to-llm-with-context
         (format "Refactor this code: %s\n\n```\n%s\n```" instruction code))
      (message "No code region or function found"))))

;; Keybindings for AI workflow
;; Note: F7, C-c a e, C-c a r are already bound in bb-ollama.el
;; Keeping these functions for advanced use cases
(global-set-key (kbd "C-c a t") 'bb-ai/generate-tests)
(global-set-key (kbd "C-c a p") 'bb-ai/send-to-llm-with-context)

;; Auto-save hook for better Claude Code integration
(add-hook 'bb-ai/pre-command-hook 'bb-ai/auto-save-buffer-maybe)

;;;; Optional: Aider integration for autonomous multi-file editing
;; Uncomment the section below to enable aidermacs
;; Requires: pip install aider-chat
;; Usage: M-x aidermacs-chat for autonomous code editing

;; (use-package aidermacs
;;   :quelpa (aidermacs :fetcher github :repo "MatthewZMD/aidermacs")
;;   :config
;;   ;; Use Ollama for offline agentic coding
;;   (setq aidermacs-model "ollama/qwen2.5-coder:32b"
;;         aidermacs-ollama-host "localhost:11434")
;;   ;; Or use OpenAI-compatible endpoint
;;   ;; (setq aidermacs-api-base "http://localhost:8080/v1"
;;   ;;       aidermacs-model "local-model")
;;   )

;; Keybindings for aider (when enabled)
;; (global-set-key (kbd "C-c A c") 'aidermacs-chat)  ; Start aider chat
;; (global-set-key (kbd "C-c A a") 'aidermacs-add-file)  ; Add file to aider
;; (global-set-key (kbd "C-c A r") 'aidermacs-reset)  ; Reset aider session

(provide 'bb-ai)
;;; bb-ai.el ends here
