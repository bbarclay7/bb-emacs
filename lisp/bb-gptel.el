;;; package --- Summary
;;; bb-gptel.el

;;; Commentary:
;; Configuration for gptel - LLM integration for Emacs
;; Supports llama.cpp OpenAI-compatible endpoints

;;; Code:

(require 'gptel)

;; Keybinding for sending to LLM
(global-set-key [f7] 'gptel-send)

;; Llama.cpp offers an OpenAI compatible API
;; Endpoint 1: alvarez on Tailscale network
(gptel-make-openai "alvarez"
  :stream t
  :protocol "http"
  :host "100.72.223.11:8080"
  :models '("alvarez-llamafile"))

;; Endpoint 2: localhost
(gptel-make-openai "localhost"
  :stream t
  :protocol "http"
  :host "127.0.0.1:8080"
  :models '("localhost-llamafile"))

(provide 'bb-gptel)
;;; bb-gptel.el ends here
