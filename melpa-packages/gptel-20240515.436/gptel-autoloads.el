;;; gptel-autoloads.el --- automatically extracted autoloads (do not edit)   -*- lexical-binding: t -*-
;; Generated by the `loaddefs-generate' function.

;; This file is part of GNU Emacs.

;;; Code:

(add-to-list 'load-path (or (and load-file-name (directory-file-name (file-name-directory load-file-name))) (car load-path)))



;;; Generated autoloads from gptel.el

(autoload 'gptel-mode "gptel" "\
Minor mode for interacting with LLMs.

This is a minor mode.  If called interactively, toggle the `GPTel
mode' mode.  If the prefix argument is positive, enable the mode,
and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `gptel-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

(fn &optional ARG)" t)
(autoload 'gptel-send "gptel" "\
Submit this prompt to the current LLM backend.

By default, the contents of the buffer up to the cursor position
are sent.  If the region is active, its contents are sent
instead.

The response from the LLM is inserted below the cursor position
at the time of sending.  To change this behavior or model
parameters, use prefix arg ARG activate a transient menu with
more options instead.

This command is asynchronous, you can continue to use Emacs while
waiting for the response.

(fn &optional ARG)" t)
(autoload 'gptel "gptel" "\
Switch to or start a chat session with NAME.

With a prefix arg, query for a (new) session name.

Ask for API-KEY if `gptel-api-key' is unset.

If region is active, use it as the INITIAL prompt.  Returns the
buffer created or switched to.

INTERACTIVEP is t when gptel is called interactively.

(fn NAME &optional _ INITIAL INTERACTIVEP)" t)
(register-definition-prefixes "gptel" '("gptel-"))


;;; Generated autoloads from gptel-anthropic.el

(autoload 'gptel-make-anthropic "gptel-anthropic" "\
Register an Anthropic API-compatible backend for gptel with NAME.

Keyword arguments:

CURL-ARGS (optional) is a list of additional Curl arguments.

HOST (optional) is the API host, \"api.anthropic.com\" by default.

MODELS is a list of available model names.

STREAM is a boolean to toggle streaming responses, defaults to
false.

PROTOCOL (optional) specifies the protocol, https by default.

ENDPOINT (optional) is the API endpoint for completions, defaults to
\"/v1/messages\".

HEADER (optional) is for additional headers to send with each
request. It should be an alist or a function that retuns an
alist, like:
((\"Content-Type\" . \"application/json\"))

KEY is a variable whose value is the API key, or function that
returns the key.

(fn NAME &key CURL-ARGS STREAM KEY (HEADER (lambda nil (when-let (key (gptel--get-api-key)) \\=`((\"x-api-key\" \\=\\, key) (\"anthropic-version\" . \"2023-06-01\"))))) (MODELS \\='(\"claude-3-sonnet-20240229\" \"claude-3-haiku-20240307\" \"claude-3-opus-20240229\")) (HOST \"api.anthropic.com\") (PROTOCOL \"https\") (ENDPOINT \"/v1/messages\"))")
(function-put 'gptel-make-anthropic 'lisp-indent-function 1)


;;; Generated autoloads from gptel-curl.el

(autoload 'gptel-curl-get-response "gptel-curl" "\
Retrieve response to prompt in INFO.

INFO is a plist with the following keys:
- :data (the data being sent)
- :buffer (the gptel buffer)
- :position (marker at which to insert the response).

Call CALLBACK with the response and INFO afterwards.  If omitted
the response is inserted into the current buffer after point.

(fn INFO &optional CALLBACK)")
(register-definition-prefixes "gptel-curl" '("gptel-"))


;;; Generated autoloads from gptel-gemini.el

(autoload 'gptel-make-gemini "gptel-gemini" "\
Register a Gemini backend for gptel with NAME.

Keyword arguments:

CURL-ARGS (optional) is a list of additional Curl arguments.

HOST (optional) is the API host, defaults to
\"generativelanguage.googleapis.com\".

MODELS is a list of available model names.

STREAM is a boolean to enable streaming responses, defaults to
false.

PROTOCOL (optional) specifies the protocol, \"https\" by default.

ENDPOINT (optional) is the API endpoint for completions, defaults to
\"/v1beta/models\".

HEADER (optional) is for additional headers to send with each
request. It should be an alist or a function that retuns an
alist, like:
((\"Content-Type\" . \"application/json\"))

KEY (optional) is a variable whose value is the API key, or
function that returns the key.

(fn NAME &key CURL-ARGS HEADER KEY (STREAM nil) (HOST \"generativelanguage.googleapis.com\") (PROTOCOL \"https\") (MODELS \\='(\"gemini-pro\" \"gemini-1.5-pro-latest\")) (ENDPOINT \"/v1beta/models\"))")
(function-put 'gptel-make-gemini 'lisp-indent-function 1)


;;; Generated autoloads from gptel-kagi.el

(autoload 'gptel-make-kagi "gptel-kagi" "\
Register a Kagi FastGPT backend for gptel with NAME.

Keyword arguments:

CURL-ARGS (optional) is a list of additional Curl arguments.

HOST is the Kagi host (with port), defaults to \"kagi.com\".

MODELS is a list of available Kagi models: only fastgpt is supported.

STREAM is a boolean to toggle streaming responses, defaults to
false.  Kagi does not support a streaming API yet.

PROTOCOL (optional) specifies the protocol, https by default.

ENDPOINT (optional) is the API endpoint for completions, defaults to
\"/api/v0/fastgpt\".

HEADER (optional) is for additional headers to send with each
request.  It should be an alist or a function that retuns an
alist, like:
((\"Content-Type\" . \"application/json\"))

KEY (optional) is a variable whose value is the API key, or
function that returns the key.

Example:
-------

(gptel-make-kagi \"Kagi\" :key my-kagi-key)

(fn NAME &key CURL-ARGS STREAM KEY (HOST \"kagi.com\") (HEADER (lambda nil \\=`((\"Authorization\" \\=\\, (concat \"Bot \" (gptel--get-api-key)))))) (MODELS \\='(\"fastgpt\" \"summarize:cecil\" \"summarize:agnes\" \"summarize:daphne\" \"summarize:muriel\")) (PROTOCOL \"https\") (ENDPOINT \"/api/v0/\"))")
(function-put 'gptel-make-kagi 'lisp-indent-function 1)


;;; Generated autoloads from gptel-ollama.el

(autoload 'gptel-make-ollama "gptel-ollama" "\
Register an Ollama backend for gptel with NAME.

Keyword arguments:

CURL-ARGS (optional) is a list of additional Curl arguments.

HOST is where Ollama runs (with port), defaults to localhost:11434

MODELS is a list of available model names.

STREAM is a boolean to toggle streaming responses, defaults to
false.

PROTOCOL (optional) specifies the protocol, http by default.

ENDPOINT (optional) is the API endpoint for completions, defaults to
\"/api/generate\".

HEADER (optional) is for additional headers to send with each
request.  It should be an alist or a function that retuns an
alist, like:
((\"Content-Type\" . \"application/json\"))

KEY (optional) is a variable whose value is the API key, or
function that returns the key.  This is typically not required
for local models like Ollama.

Example:
-------

(gptel-make-ollama
  \"Ollama\"
  :host \"localhost:11434\"
  :models \\='(\"mistral:latest\")
  :stream t)

(fn NAME &key CURL-ARGS HEADER KEY MODELS STREAM (HOST \"localhost:11434\") (PROTOCOL \"http\") (ENDPOINT \"/api/chat\"))")
(function-put 'gptel-make-ollama 'lisp-indent-function 1)
(register-definition-prefixes "gptel-ollama" '("gptel--ollama-token-count"))


;;; Generated autoloads from gptel-openai.el

(autoload 'gptel-make-openai "gptel-openai" "\
Register an OpenAI API-compatible backend for gptel with NAME.

Keyword arguments:

CURL-ARGS (optional) is a list of additional Curl arguments.

HOST (optional) is the API host, typically \"api.openai.com\".

MODELS is a list of available model names.

STREAM is a boolean to toggle streaming responses, defaults to
false.

PROTOCOL (optional) specifies the protocol, https by default.

ENDPOINT (optional) is the API endpoint for completions, defaults to
\"/v1/chat/completions\".

HEADER (optional) is for additional headers to send with each
request. It should be an alist or a function that retuns an
alist, like:
((\"Content-Type\" . \"application/json\"))

KEY (optional) is a variable whose value is the API key, or
function that returns the key.

(fn NAME &key CURL-ARGS MODELS STREAM KEY (HEADER (lambda nil (when-let (key (gptel--get-api-key)) \\=`((\"Authorization\" \\=\\, (concat \"Bearer \" key)))))) (HOST \"api.openai.com\") (PROTOCOL \"https\") (ENDPOINT \"/v1/chat/completions\"))")
(function-put 'gptel-make-openai 'lisp-indent-function 1)
(autoload 'gptel-make-azure "gptel-openai" "\
Register an Azure backend for gptel with NAME.

Keyword arguments:

CURL-ARGS (optional) is a list of additional Curl arguments.

HOST is the API host.

MODELS is a list of available model names.

STREAM is a boolean to toggle streaming responses, defaults to
false.

PROTOCOL (optional) specifies the protocol, https by default.

ENDPOINT is the API endpoint for completions.

HEADER (optional) is for additional headers to send with each
request. It should be an alist or a function that retuns an
alist, like:
((\"Content-Type\" . \"application/json\"))

KEY (optional) is a variable whose value is the API key, or
function that returns the key.

Example:
-------

(gptel-make-azure
 \"Azure-1\"
 :protocol \"https\"
 :host \"RESOURCE_NAME.openai.azure.com\"
 :endpoint
 \"/openai/deployments/DEPLOYMENT_NAME/completions?api-version=2023-05-15\"
 :stream t
 :models \\='(\"gpt-3.5-turbo\" \"gpt-4\"))

(fn NAME &key CURL-ARGS HOST (PROTOCOL \"https\") (HEADER (lambda nil \\=`((\"api-key\" \\=\\, (gptel--get-api-key))))) (KEY \\='gptel-api-key) MODELS STREAM ENDPOINT)")
(function-put 'gptel-make-azure 'lisp-indent-function 1)
(defalias 'gptel-make-gpt4all 'gptel-make-openai "\
Register a GPT4All backend for gptel with NAME.

Keyword arguments:

CURL-ARGS (optional) is a list of additional Curl arguments.

HOST is where GPT4All runs (with port), typically localhost:8491

MODELS is a list of available model names.

STREAM is a boolean to toggle streaming responses, defaults to
false.

PROTOCOL specifies the protocol, https by default.

ENDPOINT (optional) is the API endpoint for completions, defaults to
\"/api/v1/completions\"

HEADER (optional) is for additional headers to send with each
request. It should be an alist or a function that retuns an
alist, like:
((\"Content-Type\" . \"application/json\"))

KEY (optional) is a variable whose value is the API key, or
function that returns the key. This is typically not required for
local models like GPT4All.

Example:
-------

(gptel-make-gpt4all
 \"GPT4All\"
 :protocol \"http\"
 :host \"localhost:4891\"
 :models \\='(\"mistral-7b-openorca.Q4_0.gguf\"))")
(register-definition-prefixes "gptel-openai" '("gptel--json-"))


;;; Generated autoloads from gptel-org.el

(register-definition-prefixes "gptel-org" '("gptel-"))


;;; Generated autoloads from gptel-transient.el

 (autoload 'gptel-menu "gptel-transient" nil t)
 (autoload 'gptel-system-prompt "gptel-transient" nil t)
(register-definition-prefixes "gptel-transient" '("gptel-"))

;;; End of scraped data

(provide 'gptel-autoloads)

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; no-native-compile: t
;; coding: utf-8-emacs-unix
;; End:

;;; gptel-autoloads.el ends here
