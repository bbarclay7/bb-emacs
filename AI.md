# AI-Assisted Development with bb-emacs

Comprehensive guide to using AI assistance in bb-emacs, including offline coding with Ollama, workflow strategies, and tool comparisons.

## Table of Contents

- [Quick Start](#quick-start)
- [Offline AI with Ollama](#offline-ai-with-ollama)
- [When to Use Each Tool](#when-to-use-each-tool)
- [Example Workflows](#example-workflows)
- [Enabling Aider (Optional)](#enabling-aider-optional)
- [Performance Tips](#performance-tips)
- [References](#references)

---

## Quick Start

The bb-emacs AI workflow is already configured and ready to use:

### Built-in AI Functions (No Setup Required)

| Key | Function | What it does |
|-----|----------|--------------|
| `F7` | Smart LLM prompt | Send with automatic context (file, mode, project) |
| `C-c a e` | Explain code | Sends region/function to LLM for explanation |
| `C-c a t` | Generate tests | Creates comprehensive tests for code |
| `C-c a r` | Refactor code | Asks for instructions, refactors with context |
| `C-c a b` | Switch backend | Choose between Ollama, remote, or local LLMs |

### Smart Context Gathering

All AI functions automatically include:
- Current file path and major mode
- Selected region or function at point
- Project root and type (via projectile)
- Cursor position

**No more copy-pasting code into ChatGPT!**

---

## Offline AI with Ollama

Run powerful AI coding assistants completely offline on your M4 Ultra (128GB RAM).

### Installation

```bash
# Install Ollama (macOS)
brew install ollama

# Or Linux
curl -fsSL https://ollama.com/install.sh | sh

# Pull recommended coding model (~20GB download)
ollama pull qwen2.5-coder:32b

# Start Ollama service (runs in background)
ollama serve
```

**That's it!** Your Emacs configuration automatically detects and uses Ollama.

### Recommended Models

With 128GB RAM, you can run the largest models:

| Model | Size | Best For | Pull Command | RAM | Speed | Released |
|-------|------|----------|--------------|-----|-------|----------|
| **qwen3-coder** ⭐ | 480B MoE (35B active) | Agentic coding, 256k-1M context | `ollama pull qwen3-coder` | ~30GB | Fast | Jul 2025 |
| **deepseek-r1:70b** 🧠 | 70B | Reasoning + planning | `ollama pull deepseek-r1:70b` | ~45GB | Slower | Jan 2025 |
| **qwen2.5-coder:32b** | 32B | All-around coding | `ollama pull qwen2.5-coder:32b` | ~20GB | Fast | 2024 |
| **deepseek-coder:33b** | 33B | Code generation | `ollama pull deepseek-coder:33b` | ~21GB | Fast | 2024 |
| **codellama:34b** | 34B | Python, general | `ollama pull codellama:34b` | ~22GB | Fast | 2023 |
| **qwen2.5-coder:7b** | 7B | Rapid iterations | `ollama pull qwen2.5-coder:7b` | ~5GB | Instant | 2024 |

⭐ **Default:** Qwen3-Coder (latest agentic model, 69.6% on SWE-bench Verified, near Claude Sonnet 4)
🧠 **For Planning:** DeepSeek R1 (reasoning model, released Jan 20, 2025)

**Speed comparison:**
- 7B: ~0.5 seconds per response
- 32B: ~2-3 seconds per response
- 70B: ~5-10 seconds per response

### Switching Backends

Press `C-c a b` to choose:
- **Ollama-Coding** - Local models (qwen, deepseek-coder, codellama)
- **Ollama-General** - Local chat (llama3, mistral)
- **alvarez** - Remote Tailscale endpoint
- **localhost-llamacpp** - Local llama.cpp server

All your bb-ai functions (`C-c a e`, `C-c a t`, etc.) work with any backend!

### Context Window Optimization ⚠️ CRITICAL

**Default context window is only 2048 tokens - TOO SMALL for coding!**

Ollama's default context window (2048 tokens) is critically insufficient for code-related tasks. This means the model can only "see" ~1500 lines of code, which severely limits its ability to understand larger functions or files.

#### Recommended Settings

| Model | Recommended Context | Max Context | Memory Cost |
|-------|---------------------|-------------|-------------|
| **qwen3-coder** | 32768 (32k) | 1,000,000 (1M) | ~64GB for 256k |
| **qwen2.5-coder:32b** | 32768 (32k) | 32,768 (32k) | ~8GB |
| **deepseek-r1:70b** | 32768 (32k) | 64,000 (64k) | ~8GB |
| **deepseek-coder:33b** | 32768 (32k) | 32,768 (32k) | ~8GB |
| **codellama:34b** | 16384 (16k) | 16,384 (16k) | ~4GB |

**For M4 Ultra (128GB RAM):** You can easily use 32k-256k context windows!

#### Method 1: Modelfile (RECOMMENDED)

Create a custom model variant with larger context:

```bash
# Create Modelfile
cat > Modelfile << 'EOF'
FROM qwen3-coder
PARAMETER num_ctx 32768
EOF

# Build custom model
ollama create qwen3-coder-32k -f Modelfile

# Use it
ollama run qwen3-coder-32k
```

**For maximum context with Qwen3-Coder (256k):**
```bash
cat > Modelfile << 'EOF'
FROM qwen3-coder
PARAMETER num_ctx 262144
EOF

ollama create qwen3-coder-256k -f Modelfile
```

#### Method 2: Environment Variable (Global)

Set for all models system-wide:

```bash
# Add to ~/.zshrc or ~/.bashrc
export OLLAMA_CONTEXT_LENGTH=32768

# Restart Ollama
killall ollama
ollama serve
```

#### Method 3: API Parameter (Per Request)

When using gptel, it can pass context size per request (automatically handled by gptel when needed).

For Aider:
```bash
aider --model ollama/qwen3-coder \
      --ollama-url http://localhost:11434 \
      --context-tokens 32768
```

**Note:** Aider automatically overrides Ollama's default to 8k minimum for coding.

#### Memory Requirements

Context window size directly impacts VRAM usage:

- **2k context** (default): ~2GB VRAM
- **8k context** (Aider minimum): ~3GB VRAM
- **32k context** (recommended): ~10GB VRAM
- **256k context** (Qwen3-Coder max): ~64GB VRAM

**Rule of thumb:** ~1GB VRAM per 4k tokens of context

#### Verification

Check your current context window:

```bash
# Run model and check
ollama show qwen3-coder --modelfile

# Look for:
# PARAMETER num_ctx 32768
```

#### Two-Model Workflow Strategy

For optimal performance with large codebases:

1. **Planning Phase** - Use DeepSeek R1 (70B, reasoning)
   - Analyze architecture
   - Design implementation strategy
   - Plan multi-file changes
   - Context: 32k tokens

2. **Implementation Phase** - Use Qwen3-Coder (agentic)
   - Execute planned changes
   - Multi-file edits
   - Autonomous coding
   - Context: 32k-256k tokens

This approach combines deep reasoning with efficient execution.

### Privacy & Offline Benefits

✅ **Complete Privacy**
- Code never leaves your machine
- No telemetry, no logs sent to cloud
- Full GDPR/compliance

✅ **Always Available**
- Works on airplanes
- No internet required
- No API rate limits

✅ **Cost Effective**
- One-time download (~20GB)
- No ongoing API costs
- Unlimited usage

✅ **Performance**
- No network latency
- Consistent speed
- Run multiple models simultaneously

---

## When to Use Each Tool

### gptel + bb-ai.el (Current Setup)

**Best for: Understanding, learning, getting suggestions**

✅ **Use when you want:**
- Manual control over changes
- To understand code before modifying
- Quick questions or explanations
- Emacs-native workflow
- Small, focused edits

**Examples:**
- "Explain this complex algorithm" → `C-c a e`
- "How does this API work?" → `F7`
- "Suggest test cases" → `C-c a t`
- "What design pattern should I use?"
- Learning unfamiliar codebases

**Workflow:**
```
You → Ask question
LLM → Provides suggestion/explanation
You → Review, understand, implement manually
```

### Aider (Autonomous, Optional)

**Best for: Multi-file changes, autonomous implementation**

✅ **Use when you want:**
- Autonomous file editing
- Multi-file coordinated changes
- Automatic git commits
- Repository-wide refactoring
- Rapid prototyping

**Examples:**
- "Refactor auth system across 15 files"
- "Add comprehensive error handling everywhere"
- "Migrate from requests to httpx"
- "Build REST API for this model"
- "Add authentication to Flask app"

**Workflow:**
```
You → Give high-level instruction
Aider → Edits multiple files autonomously
Aider → Creates git commits
You → Review diff, iterate or accept
```

### Comparison Table

| Feature | gptel + bb-ai | Aider |
|---------|---------------|-------|
| **Control** | High - you implement | Low - AI implements |
| **Speed** | Manual implementation | Autonomous |
| **Multi-file** | One at a time | Coordinated edits |
| **Git integration** | Manual commits | Auto-commit |
| **Learning** | Excellent | Limited |
| **Emacs native** | Yes | Via aidermacs |
| **Best for** | Understanding | Doing |

---

## Example Workflows

### Workflow 1: Understanding Unfamiliar Code

**Scenario:** You inherit a complex authentication module

```
1. Open auth.py
2. Find complex function verify_token()
3. Select the function (mark region)
4. Press C-c a e (explain code)

Result:
"This function implements JWT token verification using RS256...
It checks expiration, validates signature, extracts claims..."

5. Press F7 for follow-up: "What happens if token is expired?"
6. Read explanation, now you understand the code
```

**Time saved:** 30 minutes of reading docs/code

### Workflow 2: Test Generation

**Scenario:** You wrote a new user registration function

```python
# Your code in user.py
def register_user(email, password, username):
    # Validate email format
    # Hash password
    # Check username uniqueness
    # Create user in database
    # Send verification email
    return user
```

```
1. Select the register_user function
2. Press C-c a t (generate tests)
3. LLM generates comprehensive test suite in gptel buffer:

def test_register_user_success():
    ...

def test_register_user_invalid_email():
    ...

def test_register_user_duplicate_username():
    ...

def test_register_user_weak_password():
    ...

4. Review suggestions
5. Copy relevant tests to test_user.py
6. Adapt to your testing framework
7. Commit manually
```

**Time saved:** 45 minutes of test writing

### Workflow 3: Large Refactoring (Aider)

**Scenario:** Migrate authentication from sessions to JWT

**Using terminal aider:**
```bash
$ cd your-project
$ aider --model ollama/qwen2.5-coder:32b

aider> Refactor authentication to use JWT tokens instead of sessions.
       Update all views, models, and tests. Keep backward compatibility.

[Aider analyzes repository]
[Aider edits: auth.py, models.py, views.py, middleware.py]
[Aider updates: tests/test_auth.py, tests/test_views.py]
[Auto-commit: "Refactor: Migrate authentication to JWT tokens"]

aider> Add token refresh endpoint and expiration handling

[Aider adds new endpoint, updates models]
[Auto-commit: "Add JWT token refresh and expiration"]

aider> /diff
[Shows all changes]

$ git log --oneline
a3b4c5d Add JWT token refresh and expiration
2e3f4a5 Refactor: Migrate authentication to JWT tokens
```

**Or using aidermacs in Emacs:**
```
M-x aidermacs-chat
> Refactor authentication to use JWT tokens
[Aider works autonomously, you see progress in Emacs]
[Check git log when done]
```

**Time saved:** 3-4 hours of refactoring + testing

### Workflow 4: Hybrid Approach (Recommended)

**Scenario:** Build new feature with full understanding

```
Phase 1: EXPLORE with gptel
1. F7: "What's the best way to implement rate limiting in Flask?"
2. Read recommendations
3. C-c a e: Explain example rate limiter implementation
4. Understand approach

Phase 2: IMPLEMENT with Aider
5. Terminal: aider --model ollama/qwen2.5-coder:32b
6. "Implement token bucket rate limiting with Redis backend"
7. [Aider creates rate_limiter.py, updates routes, adds tests]
8. [Auto-commits]

Phase 3: REVIEW with gptel
9. Open changed files in Emacs
10. git diff
11. Select questionable code
12. C-c a e: "Explain why this uses sliding window"
13. Iterate if needed: C-c a r "Refactor to use decorator pattern"
14. Review suggestions, implement manually or with Aider
```

**Best of both worlds:** Understanding + Speed

---

## Enabling Aider (Optional)

Aider provides autonomous multi-file editing with automatic git commits.

### Installation

```bash
# Install aider CLI
pip install aider-chat

# Or use pipx for isolation
pipx install aider-chat

# Verify installation
aider --version
```

### Using Aider from Terminal

```bash
# Navigate to project
cd ~/projects/myapp

# Start aider with Ollama
aider --model ollama/qwen2.5-coder:32b

# Or with specific files
aider app.py models.py --model ollama/qwen2.5-coder:32b
```

**Aider commands:**
- `/add file.py` - Add file to context
- `/drop file.py` - Remove file from context
- `/diff` - Show pending changes
- `/undo` - Undo last change
- `/commit` - Commit changes
- `/help` - Show all commands

### Enabling aidermacs (Emacs Integration)

For Emacs-native Aider experience:

1. Install aider CLI (above)
2. Edit `/lisp/bb-ai.el`
3. Uncomment lines 151-165 (aidermacs configuration)
4. Restart Emacs

**Keybindings:**
- `C-c A c` - Start aider chat
- `C-c A a` - Add file to context
- `C-c A r` - Reset session

---

## Performance Tips

### For M4 Ultra (128GB RAM)

✅ **Run multiple models simultaneously**
```bash
# Terminal 1 - Coding
ollama run qwen3-coder

# Terminal 2 - Reasoning/Planning
ollama run deepseek-r1:70b

# Terminal 3 - Quick iterations
ollama run qwen2.5-coder:7b
```

Use coding model in Emacs, reasoning model for architecture/planning, fast model for iterations.

✅ **Choose model by task**
- **7B (qwen2.5-coder:7b)**: Quick iterations, testing ideas, learning syntax
- **32B (qwen2.5-coder:32b)**: Production coding, refactoring, proven workhorse
- **35B active (qwen3-coder)**: Agentic coding, multi-file changes, complex tasks
- **70B (deepseek-r1)**: Architecture planning, reasoning, critical decisions

✅ **Keep models loaded**
```bash
# Pre-load common models at startup
ollama pull qwen3-coder
ollama pull deepseek-r1:70b
ollama pull qwen2.5-coder:7b

# CRITICAL: Create 32k context versions (see Context Window Optimization section)
cat > Modelfile << 'EOF'
FROM qwen3-coder
PARAMETER num_ctx 32768
EOF
ollama create qwen3-coder-32k -f Modelfile
```

First query loads model (~10s), subsequent queries are instant.

✅ **Two-model workflow for best results**

**Phase 1 - Planning** (Use DeepSeek R1):
```
C-c a b → Switch to Ollama-General (DeepSeek R1)
F7 → "Analyze this architecture and suggest refactoring approach"
[Deep reasoning, comprehensive planning]
```

**Phase 2 - Implementation** (Use Qwen3-Coder):
```
C-c a b → Switch to Ollama-Coding (Qwen3-Coder)
Use Aider: aider --model ollama/qwen3-coder-32k
[Autonomous multi-file editing based on plan]
```

**Phase 3 - Quick iterations** (Use 7B for speed):
```
C-c a b → Switch to qwen2.5-coder:7b
[Fast responses for minor tweaks and testing]
```

### Working with Large Files

**Large files:**
- Select specific function instead of whole file
- Use `C-c a e` on focused regions
- Ensure you've configured 32k context (see Context Window Optimization section)
- Aider handles large contexts better than single prompts

**Repository-wide understanding:**
- Use Aider with Qwen3-Coder (has repository map, 256k-1M context)
- gptel works best with focused context (functions/classes)
- Consider DeepSeek R1 for architectural analysis

---

## Troubleshooting

### Ollama not responding

```bash
# Check if Ollama is running
curl http://localhost:11434/api/tags

# Restart Ollama
killall ollama
ollama serve

# Check logs
tail -f ~/.ollama/logs/server.log
```

### Model too slow

**Solutions:**
1. Use smaller model: `C-c a b` → qwen2.5-coder:7b (5GB, instant responses)
2. Check context window isn't too large: `ollama show qwen3-coder --modelfile`
3. Close other applications to free RAM
4. Check model is loaded: `ollama list`
5. Use quantized model if available: `qwen2.5-coder:7b-q4` (4-bit quantization)
6. For M4 Ultra: You should handle 70B models easily; check RAM usage with `htop`

### "Backend not responding" in gptel

```elisp
;; In bb-gptel.el, verify host/port
(gptel-make-ollama "Ollama"
  :host "localhost:11434"  ; Default Ollama port
  :stream t
  :models '(qwen3-coder))

;; Check if Ollama is running
;; Terminal: curl http://localhost:11434/api/tags
```

### Aider can't find Ollama

```bash
# Use full model specification with custom context
aider --model ollama/qwen3-coder \
      --ollama-url http://localhost:11434 \
      --context-tokens 32768

# Or use your custom 32k model
aider --model ollama/qwen3-coder-32k --ollama-url http://localhost:11434
```

---

## References

### Emacs AI Integration

- [gptel - Simple LLM Client for Emacs](https://github.com/karthink/gptel)
- [TIL: Local LLMs with Ollama and gptel](https://www.alcarney.me/blog/2024/local-llms-with-ollama-and-gptel/)
- [Ellama - LLM Tool for Emacs](https://github.com/s-kostyaev/ellama)
- [Ollama Buddy - Local LLM Integration](https://www.dyerdwelling.family/emacs/20250207092636-emacs--ollama-buddy-local-llm-integration-for-emacs/)
- [Aidermacs - AI Pair Programming](https://github.com/MatthewZMD/aidermacs)
- [AI in Emacs - Will Schenk](https://willschenk.com/labnotes/2024/ai_in_emacs/)

### Agentic Coding Tools

- [Aider Official Documentation](https://aider.chat/docs/)
- [Aider Git Integration](https://aider.chat/docs/git.html)
- [Aider Repository Map](https://aider.chat/docs/repomap.html)
- [Getting Started with Aider](https://blog.openreplay.com/getting-started-aider-ai-coding-terminal/)
- [Aider Review: A Developer's Month](https://www.blott.com/blog/post/aider-review-a-developers-month-with-this-terminal-based-code-assistant)

### Comparisons & Benchmarks

- [Agentic CLI Tools Compared: Claude Code vs Cline vs Aider](https://research.aimultiple.com/agentic-cli/)
- [Claude Code vs Cursor Deep Comparison](https://www.qodo.ai/blog/claude-code-vs-cursor/)
- [Testing AI Coding Agents 2025](https://render.com/blog/ai-coding-agents-benchmark)
- [Best AI Coding Agents 2026](https://www.faros.ai/blog/best-ai-coding-agents-2026)
- [The Complete Guide to Local AI Coding in 2026](https://dev.to/murat_aslan_fa44b545aaa2c/the-complete-guide-to-local-ai-coding-in-2026-205l)

### Latest Model Releases (2025)

- [Qwen3-Coder: Alibaba's Game-Changing Agentic AI Coding Model](https://medium.com/@cognidownunder/qwen3-coder-alibabas-game-changing-open-source-agentic-ai-coding-model-3cf34dcc8d7a)
- [Alibaba Unveils Qwen3 Models for Coding](https://www.alizila.com/alibaba-unveils-new-qwen3-models-for-coding-complexing-reasoning-and-machine-translation/)
- [Alibaba Targets Agentic AI Crown with Qwen3-Coder](https://winbuzzer.com/2025/07/23/alibaba-targets-agentic-ai-crown-with-qwen3-coder-release-xcxwbn/)
- [How to Set Up and Run Qwen3 Locally With Ollama](https://www.datacamp.com/tutorial/qwen3-ollama)

### Local AI Coding Alternatives

- [Tabby - Self-hosted AI Coding Assistant](https://github.com/TabbyML/tabby)
- [Continue.dev - Open Source AI Code Assistant](https://continue.dev/)
- [Best Self-hosted AI Coding Alternatives](https://www.virtualizationhowto.com/2025/05/best-self-hosted-github-copilot-ai-coding-alternatives/)
- [Replacing GitHub Copilot with Ollama](https://jasongiroux.com/2024/12/11/local-copilot/)
- [Top 10 Open Source AI Coding Tools](https://www.femaleswitch.com/directories/tpost/6yvgmjs4b1-top-10-open-source-alternatives-to-githu)
- [Privy - Open Source AI Assistant](https://github.com/srikanth235/privy)
- [FauxPilot - Self-hosted Coding Assistant](https://github.com/fauxpilot/fauxpilot)

### Ollama & Local Models

- [Ollama Official Site](https://ollama.com/)
- [Ollama GitHub Repository](https://github.com/ollama/ollama)
- [Ollama Code Generation Tutorial](https://markaicode.com/ollama-code-generation-ai-programming-assistant/)
- [Continue.dev with Ollama](https://markaicode.com/continue-dev-ollama-ai-code-completion-tutorial/)

### Model Information

- **Qwen3-Coder** (Latest): [Qwen3-Coder GitHub](https://github.com/QwenLM/Qwen3-Coder) | [Alibaba Announcement](https://www.alibabacloud.com/blog/alibaba-unveils-cutting-edge-ai-coding-model-qwen3-coder_602399) | [Ollama Library](https://ollama.com/library/qwen3-coder)
- **Qwen3**: [Qwen3 GitHub](https://github.com/QwenLM/Qwen3) | [Official Blog](https://qwenlm.github.io/blog/qwen3/)
- **DeepSeek R1** (Reasoning): [DeepSeek R1 Release](https://github.com/deepseek-ai/DeepSeek-R1) | [Ollama Library](https://ollama.com/library/deepseek-r1)
- **Qwen2.5-Coder**: [Alibaba Cloud Qwen](https://github.com/QwenLM/Qwen2.5-Coder)
- **DeepSeek-Coder**: [DeepSeek AI](https://github.com/deepseek-ai/DeepSeek-Coder)
- **CodeLlama**: [Meta AI](https://github.com/facebookresearch/codellama)

---

## Next Steps

1. **Install Ollama** (if not already): `brew install ollama`
2. **Pull latest models**:
   ```bash
   ollama pull qwen3-coder        # Latest agentic coding model
   ollama pull deepseek-r1:70b    # Reasoning model
   ollama pull qwen2.5-coder:7b   # Fast iteration model
   ```
3. **⚠️ CRITICAL: Configure 32k context** (see Context Window Optimization section):
   ```bash
   cat > Modelfile << 'EOF'
   FROM qwen3-coder
   PARAMETER num_ctx 32768
   EOF
   ollama create qwen3-coder-32k -f Modelfile
   ```
4. **Try it out**: Open a file, press `C-c a e` to explain code
5. **Explore**: Use `F7` for free-form questions with automatic context
6. **Switch backends**: Press `C-c a b` to choose between models
7. **Advanced**: Install aider for autonomous multi-file editing

Your Emacs is now a powerful AI-assisted development environment with state-of-the-art agentic coding capabilities that works completely offline!

---

**Back to:** [Main README](README.md) | [Structure](README.md#structure) | [Installation](README.md#installation)
