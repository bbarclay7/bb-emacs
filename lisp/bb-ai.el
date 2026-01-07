;;; package --- Summary
;;; bb-ai.el

;;; Commentary:
;; AI-assisted development: Copilot, gptel (LLM), and Claude Code integration hooks

;;; Code:

(require 'gptel nil t)

;;;; Copilot configuration
(when (not (getenv "EC_SITE"))
  (let ((copilot-path (expand-file-name "copilot.el" user-emacs-directory)))
    (if (file-exists-p (concat copilot-path "/copilot.el"))
        (progn
          (use-package copilot
            :load-path copilot-path
            :diminish)
          (load "bb-copilot.el"))
      (warn "copilot.el not found at %s - run 'git submodule update --init --recursive'" copilot-path))))

;;;; gptel - LLM integration
(use-package gptel
  :ensure t
  :defer t
  :config (load "bb-gptel.el"))

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

;; Function to send context to gptel with smart defaults
(defun bb-ai/send-to-llm-with-context (prompt)
  "Send PROMPT to LLM with automatic context gathering."
  (interactive "sPrompt: ")
  (let* ((context (bb-ai/gather-context))
         (file (cdr (assoc 'file context)))
         (mode (cdr (assoc 'mode context)))
         (region (cdr (assoc 'region context)))
         (full-prompt (format "File: %s\nMode: %s\n\n%s%s"
                              file
                              mode
                              (if region (format "Selected code:\n```\n%s\n```\n\n" region) "")
                              prompt)))
    (with-temp-buffer
      (insert full-prompt)
      (gptel-send))))

;; Enhanced F7 keybinding with context
(global-set-key [f7] 'bb-ai/send-to-llm-with-context)

;; Hook for when entering programming modes
(defun bb-ai/prog-mode-setup ()
  "Setup AI assistance for programming modes."
  (run-hooks 'bb-ai/pre-command-hook)
  ;; Enable copilot if available
  (when (fboundp 'copilot-mode)
    (copilot-mode 1)))

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
(global-set-key (kbd "C-c a e") 'bb-ai/explain-code)
(global-set-key (kbd "C-c a t") 'bb-ai/generate-tests)
(global-set-key (kbd "C-c a r") 'bb-ai/refactor-code)
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
