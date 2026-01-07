;;; package --- Summary
;;; bb-gptel.el

;;; Commentary:
;; Configuration for gptel - LLM integration for Emacs
;; Supports llama.cpp OpenAI-compatible endpoints and Ollama

;;; Code:

(require 'gptel)

;; Keybinding for sending to LLM (overridden in bb-ai.el with context-aware version)
(global-set-key [f7] 'gptel-send)

;;;; Remote llama.cpp endpoints (for when online)

;; Endpoint 1: alvarez on Tailscale network
(gptel-make-openai "alvarez"
  :stream t
  :protocol "http"
  :host "100.72.223.11:8080"
  :models '("alvarez-llamafile"))

;; Endpoint 2: localhost llama.cpp
(gptel-make-openai "localhost-llamacpp"
  :stream t
  :protocol "http"
  :host "127.0.0.1:8080"
  :models '("localhost-llamafile"))

;;;; Ollama backends (for offline work with local models)
;; Requires: brew install ollama (macOS) or curl -fsSL https://ollama.com/install.sh | sh (Linux)
;; Then: ollama pull <model-name>

;; Ollama backend with coding-focused models
(gptel-make-ollama "Ollama-Coding"
  :host "localhost:11434"
  :stream t
  :models '(qwen2.5-coder:32b      ; Excellent coding model (32B)
            deepseek-coder:33b      ; Strong code generation (33B)
            codellama:34b           ; Python & general coding (34B)
            qwen2.5-coder:7b))      ; Faster, smaller coding model (7B)

;; Ollama backend with general-purpose models
(gptel-make-ollama "Ollama-General"
  :host "localhost:11434"
  :stream t
  :models '(llama3.2:latest         ; Fast general purpose
            deepseek-r1:70b         ; Reasoning + coding (requires 128GB RAM)
            qwen2.5:32b             ; General purpose chat
            mistral:latest))        ; Fast and capable

;; Set default backend (choose one):
;; For offline coding work with M4 Ultra:
(setq gptel-model 'qwen2.5-coder:32b
      gptel-backend (gptel-make-ollama "Ollama"
                      :host "localhost:11434"
                      :stream t
                      :models '(qwen2.5-coder:32b
                                deepseek-coder:33b
                                codellama:34b
                                qwen2.5-coder:7b
                                llama3.2:latest)))

;; Helper function to switch between backends
(defun bb-gptel/switch-backend ()
  "Interactively switch gptel backend (remote, local, Ollama)."
  (interactive)
  (let ((choice (completing-read "Select backend: "
                                 '("Ollama-Coding" "Ollama-General"
                                   "alvarez" "localhost-llamacpp")
                                 nil t)))
    (pcase choice
      ("Ollama-Coding"
       (setq gptel-backend (gptel-make-ollama "Ollama-Coding"
                             :host "localhost:11434"
                             :stream t
                             :models '(qwen2.5-coder:32b deepseek-coder:33b codellama:34b))
             gptel-model 'qwen2.5-coder:32b)
       (message "Switched to Ollama coding models (offline)"))
      ("Ollama-General"
       (setq gptel-backend (gptel-make-ollama "Ollama-General"
                             :host "localhost:11434"
                             :stream t
                             :models '(llama3.2:latest qwen2.5:32b mistral:latest))
             gptel-model 'llama3.2:latest)
       (message "Switched to Ollama general models (offline)"))
      ("alvarez"
       (setq gptel-backend (gptel-make-openai "alvarez"
                             :stream t :protocol "http" :host "100.72.223.11:8080"
                             :models '("alvarez-llamafile"))
             gptel-model "alvarez-llamafile")
       (message "Switched to alvarez (Tailscale remote)"))
      ("localhost-llamacpp"
       (setq gptel-backend (gptel-make-openai "localhost-llamacpp"
                             :stream t :protocol "http" :host "127.0.0.1:8080"
                             :models '("localhost-llamafile"))
             gptel-model "localhost-llamafile")
       (message "Switched to localhost llama.cpp")))))

;; Keybinding to switch backends
(global-set-key (kbd "C-c a b") 'bb-gptel/switch-backend)

(provide 'bb-gptel)
;;; bb-gptel.el ends here
