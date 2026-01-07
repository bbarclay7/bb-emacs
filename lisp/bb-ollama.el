;;; bb-ollama.el --- Simple direct Ollama integration

;;; Commentary:
;; Direct Ollama integration via curl, bypassing gptel issues
;; Uses Ollama's OpenAI-compatible API for reliability

;;; Code:

(defvar bb-ollama-model "qwen3-coder-256k:latest"
  "Default Ollama model to use.")

(defvar bb-ollama-host "localhost:11434"
  "Ollama server host and port.")

(defun bb-ollama-query (prompt &optional context)
  "Query Ollama with PROMPT and optional CONTEXT.
CONTEXT should be a string of additional context (like selected code)."
  (interactive
   (list (read-string "Prompt: ")
         (when (use-region-p)
           (buffer-substring-no-properties (region-beginning) (region-end)))))

  (let* ((messages (if context
                       (list (list :role "system" :content "You are a helpful coding assistant.")
                             (list :role "user" :content (format "Context:\n```\n%s\n```\n\n%s" context prompt)))
                     (list (list :role "user" :content prompt))))
         (json-object-type 'alist)
         (json-array-type 'list)
         (json-key-type 'keyword)
         (payload (json-encode (list :model bb-ollama-model
                                    :messages messages
                                    :stream :json-false)))
         (url (format "http://%s/v1/chat/completions" bb-ollama-host))
         (response-buffer (get-buffer-create "*Ollama Response*")))

    (message "Querying Ollama (%s)..." bb-ollama-model)

    ;; Make async request
    (let ((proc (start-process
                 "ollama-query"
                 response-buffer
                 "curl"
                 "-s"
                 "-X" "POST"
                 url
                 "-H" "Content-Type: application/json"
                 "-d" payload)))

      (set-process-sentinel
       proc
       (lambda (process event)
         (when (string= event "finished\n")
           (with-current-buffer (process-buffer process)
             (goto-char (point-min))
             (let* ((raw-response (buffer-substring-no-properties (point-min) (point-max)))
                    (json-object-type 'alist)
                    (json-array-type 'list)
                    (json-key-type 'keyword))
               (goto-char (point-min))
               (let* ((response (condition-case err
                                   (json-read)
                                 (error (progn
                                         (message "JSON parse error: %S" err)
                                         nil))))
                      (choices (when response (cdr (assoc :choices response))))
                      (first-choice (when choices (elt choices 0)))
                      (message-obj (when first-choice (cdr (assoc :message first-choice))))
                      (content (when message-obj (cdr (assoc :content message-obj)))))
                 (erase-buffer)
                 (if content
                     (progn
                       (insert "# Ollama Response\n")
                       (insert (format "Model: %s\n\n" bb-ollama-model))
                       (insert content)
                       (goto-char (point-min))
                       (when (fboundp 'markdown-mode)
                         (markdown-mode))
                       (pop-to-buffer (current-buffer))
                       (message "Ollama response ready!"))
                   (insert "Error: Could not parse response\n\n")
                   (insert "Debug info:\n")
                   (insert (format "Response object exists: %s\n" (if response "yes" "no")))
                   (insert (format "Choices exists: %s\n" (if choices "yes" "no")))
                   (insert (format "First choice exists: %s\n" (if first-choice "yes" "no")))
                   (insert (format "Message object exists: %s\n" (if message-obj "yes" "no")))
                   (insert "\nRaw response:\n")
                   (insert raw-response)
                   (goto-char (point-min))
                   (pop-to-buffer (current-buffer))
                   (message "Error querying Ollama - check *Ollama Response* buffer for details")))))))))) ; Close if, let*, with-current-buffer, when, lambda, set-process-sentinel, let for proc, let* for bindings, defun

(defun bb-ollama-explain-code ()
  "Explain the selected code using Ollama."
  (interactive)
  (if (use-region-p)
      (bb-ollama-query "Explain this code in detail."
                      (buffer-substring-no-properties (region-beginning) (region-end)))
    (message "No region selected")))

(defun bb-ollama-complete-code ()
  "Complete the selected code using Ollama."
  (interactive)
  (if (use-region-p)
      (bb-ollama-query "Complete this code. Only output the completion, no explanations."
                      (buffer-substring-no-properties (region-beginning) (region-end)))
    (message "No region selected")))

(defun bb-ollama-review-code ()
  "Review the selected code for bugs and improvements."
  (interactive)
  (if (use-region-p)
      (bb-ollama-query "Review this code for bugs, security issues, and potential improvements."
                      (buffer-substring-no-properties (region-beginning) (region-end)))
    (message "No region selected")))

(defun bb-ollama-set-model ()
  "Interactively select Ollama model."
  (interactive)
  (let ((model (completing-read "Select model: "
                               '("qwen3-coder-256k:latest"
                                 "qwen3-coder-32k:latest"
                                 "qwen2.5-coder:32b"
                                 "deepseek-r1:70b"
                                 "deepseek-coder:33b")
                               nil nil nil nil
                               bb-ollama-model)))
    (setq bb-ollama-model model)
    (message "Ollama model set to: %s" model)))

;; Keybindings (same as before but using our custom functions)
(global-set-key (kbd "<f7>") 'bb-ollama-query)
(global-set-key (kbd "C-c a e") 'bb-ollama-explain-code)
(global-set-key (kbd "C-c a c") 'bb-ollama-complete-code)
(global-set-key (kbd "C-c a r") 'bb-ollama-review-code)
(global-set-key (kbd "C-c a m") 'bb-ollama-set-model)

(provide 'bb-ollama)
;;; bb-ollama.el ends here
