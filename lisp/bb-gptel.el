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

;;;; Ollama Context Window - Extended Context Modelfiles ✅
;;
;; This config uses EXTENDED CONTEXT custom modelfiles:
;;   - qwen3-coder-256k:latest (256k context - MASSIVE)
;;   - qwen3-coder-32k:latest (32k context)
;;
;; These were created via Modelfile with:
;;   FROM qwen3-coder
;;   PARAMETER num_ctx 262144  (or 32768)
;;
;; VERIFY your modelfiles: ollama list
;;   Should see: qwen3-coder-256k:latest and qwen3-coder-32k:latest
;;
;; Context size impact:
;;   - 2048 (default) = ~1.5k words (TOO SMALL for coding)
;;   - 32768 = ~24k words (good for most coding tasks)
;;   - 262144 = ~200k words (ENTIRE large codebases)
;;
;; Memory cost: ~1GB VRAM per 4k context increase
;; 256k context = ~64GB VRAM (easily fits M4 Ultra 128GB RAM)

;; Ollama backend with coding-focused models
;; Using extended-context custom modelfiles (see: ollama list)
(gptel-make-ollama "Ollama-Coding"
  :host "localhost:11434"
  :stream t
  :models '("qwen3-coder-256k:latest"  ; ⭐ 256k context (480B MoE, 35B active, Jul 2025)
            "qwen3-coder-32k:latest"   ; 32k context variant
            "qwen2.5-coder:32b"        ; Excellent all-around coding (32B)
            "deepseek-coder:33b"       ; Strong code generation (33B)
            "codellama:34b"            ; Python & general coding (34B)
            "qwen2.5-coder:7b"))       ; Faster, smaller coding model (7B)

;; Ollama backend with general-purpose models
(gptel-make-ollama "Ollama-General"
  :host "localhost:11434"
  :stream t
  :models '("deepseek-r1:70b"       ; ⭐ Reasoning + coding (70B, Jan 2025)
            "qwen3:30b-a3b"         ; Latest general purpose (30B MoE, 3B active)
            "qwen2.5:32b"           ; Previous-gen chat (32B)
            "llama3.2:latest"       ; Fast general purpose
            "mistral:latest"))      ; Fast and capable

;; Set default backend (choose one):
;; For offline coding work with M4 Ultra:
(setq gptel-model "qwen3-coder-256k:latest"  ; 256k context - extended context custom model
      gptel-backend (gptel-make-ollama "Ollama"
                      :host "localhost:11434"
                      :stream t
                      :models '("qwen3-coder-256k:latest"  ; Agentic coding (256k context)
                                "qwen3-coder-32k:latest"   ; 32k context variant
                                "qwen2.5-coder:32b"        ; Proven coding workhorse
                                "deepseek-r1:70b"          ; Reasoning model
                                "deepseek-coder:33b"
                                "codellama:34b"
                                "qwen2.5-coder:7b"
                                "llama3.2:latest")))

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
                             :models '("qwen3-coder-256k:latest" "qwen3-coder-32k:latest" "qwen2.5-coder:32b" "deepseek-coder:33b" "codellama:34b"))
             gptel-model "qwen3-coder-256k:latest")
       (message "Switched to Ollama coding models (offline) - Default: Qwen3-Coder-256k"))
      ("Ollama-General"
       (setq gptel-backend (gptel-make-ollama "Ollama-General"
                             :host "localhost:11434"
                             :stream t
                             :models '("deepseek-r1:70b" "qwen3:30b-a3b" "qwen2.5:32b" "llama3.2:latest" "mistral:latest"))
             gptel-model "deepseek-r1:70b")
       (message "Switched to Ollama general models (offline) - Default: DeepSeek R1"))
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
