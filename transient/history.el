((gptel--infix-provider #s(gptel-openai "ChatGPT" "api.openai.com"
					#[0 "\300 \211\205\f \301\302PBC\207"
					    [gptel--get-api-key "Authorization" "Bearer "]
					    4]
					"https" t "/v1/chat/completions" gptel-api-key
					("gpt-3.5-turbo" "gpt-3.5-turbo-16k" "gpt-4o-mini" "gpt-4" "gpt-4o" "gpt-4-turbo" "gpt-4-turbo-preview" "gpt-4-32k" "gpt-4-1106-preview" "gpt-4-0125-preview")
					"https://api.openai.com/v1/chat/completions" nil)
			#s(gptel-openai "llama-cpp2" "127.0.0.1:8080"
					#[0 "\300 \211\205\f \301\302PBC\207"
					    [gptel--get-api-key "Authorization" "Bearer "]
					    4]
					"http" t "/v1/chat/completions" nil
					("localhost-llamafile")
					"http://127.0.0.1:8080/v1/chat/completions" nil)
			#s(gptel-openai "llama-cpp" "100.72.223.11:8080"
					#[0 "\300 \211\205\f \301\302PBC\207"
					    [gptel--get-api-key "Authorization" "Bearer "]
					    4]
					"http" t "/v1/chat/completions" nil
					("alvarez-llamafile")
					"http://100.72.223.11:8080/v1/chat/completions" nil)
			#s(gptel-openai "ChatGPT" "api.openai.com"
					#[0 "\300 \211\205\f \301\302PBC\207"
					    [gptel--get-api-key "Authorization" "Bearer "]
					    4]
					"https" t "/v1/chat/completions" gptel-api-key
					("gpt-3.5-turbo" "gpt-3.5-turbo-16k" "gpt-4" "gpt-4o" "gpt-4-turbo" "gpt-4-turbo-preview" "gpt-4-32k" "gpt-4-1106-preview" "gpt-4-0125-preview")
					"https://api.openai.com/v1/chat/completions" nil)
			#s(gptel-openai "ChatGPT" "api.openai.com"
					#[0 "\300 \211\205\f \301\302PBC\207"
					    [gptel--get-api-key "Authorization" "Bearer "]
					    4]
					"https" t "/v1/chat/completions" gptel-api-key
					("gpt-3.5-turbo" "gpt-3.5-turbo-16k" "gpt-4" "gpt-4-turbo-preview" "gpt-4-32k" "gpt-4-1106-preview" "gpt-4-0125-preview")
					"https://api.openai.com/v1/chat/completions" nil))
 (gptel--infix-rewrite-prompt "You are a python-interaction programmer. Refactor the following code. Generate only code, no explanation." "You are a lisp-interaction programmer. Refactor the following code. Generate only code, no explanation.")
 (gptel-menu
  ("m")
  ("i"))
 (gptel-rewrite-menu nil)
 (gptel-system-prompt nil))
