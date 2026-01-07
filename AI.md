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

| Model | Size | Best For | Pull Command | RAM | Speed |
|-------|------|----------|--------------|-----|-------|
| **qwen2.5-coder:32b** ⭐ | 32B | All-around coding | `ollama pull qwen2.5-coder:32b` | ~20GB | Fast |
| **deepseek-coder:33b** | 33B | Code generation | `ollama pull deepseek-coder:33b` | ~21GB | Fast |
| **codellama:34b** | 34B | Python, general | `ollama pull codellama:34b` | ~22GB | Fast |
| **qwen2.5-coder:7b** | 7B | Rapid iterations | `ollama pull qwen2.5-coder:7b` | ~5GB | Instant |
| **deepseek-r1:70b** | 70B | Max quality | `ollama pull deepseek-r1:70b` | ~45GB | Slower |

⭐ **Default:** Qwen2.5-Coder 32B (excellent balance)

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
# Terminal 1
ollama run qwen2.5-coder:32b

# Terminal 2
ollama run llama3.2:latest
```

Use coding model in Emacs, general model for research/docs.

✅ **Choose model size by task**
- **7B**: Active coding, quick iterations, testing ideas
- **32B**: Production coding, refactoring, most tasks
- **70B**: Complex architecture, critical decisions, learning

✅ **Keep models loaded**
```bash
# Pre-load common models at startup
ollama pull qwen2.5-coder:32b
ollama pull qwen2.5-coder:7b
```

First query loads model (~10s), subsequent queries are instant.

✅ **Use smaller models for iterative work**

When prototyping or learning:
```
C-c a b → Switch to qwen2.5-coder:7b
[Fast iterations, instant responses]

When ready to implement:
C-c a b → Switch to qwen2.5-coder:32b
[Better quality for production code]
```

### Context Window Optimization

**Large files:**
- Select specific function instead of whole file
- Use `C-c a e` on focused regions
- Aider handles large contexts better than single prompts

**Repository-wide understanding:**
- Use Aider (has repository map)
- gptel works best with focused context

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
1. Use smaller model: `C-c a b` → qwen2.5-coder:7b
2. Close other applications
3. Check model is loaded: `ollama list`
4. Use quantized model: `qwen2.5-coder:7b-q4` (4-bit quantization)

### "Backend not responding" in gptel

```elisp
;; In bb-gptel.el, verify host/port
(gptel-make-ollama "Ollama"
  :host "localhost:11434"  ; Default Ollama port
  :stream t
  :models '(qwen2.5-coder:32b))
```

### Aider can't find Ollama

```bash
# Use full model specification
aider --model ollama/qwen2.5-coder:32b --ollama-url http://localhost:11434
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

### GitHub Copilot Alternatives

- [Tabby - Self-hosted AI Coding Assistant](https://github.com/TabbyML/tabby)
- [Best Self-hosted GitHub Copilot Alternatives](https://www.virtualizationhowto.com/2025/05/best-self-hosted-github-copilot-ai-coding-alternatives/)
- [Replacing GitHub Copilot with Ollama](https://jasongiroux.com/2024/12/11/local-copilot/)
- [Top 10 Open Source Alternatives to GitHub Copilot](https://www.femaleswitch.com/directories/tpost/6yvgmjs4b1-top-10-open-source-alternatives-to-githu)
- [Privy - Open Source Copilot Alternative](https://github.com/srikanth235/privy)
- [FauxPilot - GitHub Copilot Server Alternative](https://github.com/fauxpilot/fauxpilot)

### Ollama & Local Models

- [Ollama Official Site](https://ollama.com/)
- [Ollama GitHub Repository](https://github.com/ollama/ollama)
- [Ollama Code Generation Tutorial](https://markaicode.com/ollama-code-generation-ai-programming-assistant/)
- [Continue.dev with Ollama](https://markaicode.com/continue-dev-ollama-ai-code-completion-tutorial/)

### Model Information

- **Qwen2.5-Coder**: [Alibaba Cloud Qwen](https://github.com/QwenLM/Qwen2.5-Coder)
- **DeepSeek-Coder**: [DeepSeek AI](https://github.com/deepseek-ai/DeepSeek-Coder)
- **CodeLlama**: [Meta AI](https://github.com/facebookresearch/codellama)

---

## Next Steps

1. **Install Ollama** (if not already): `brew install ollama`
2. **Pull a model**: `ollama pull qwen2.5-coder:32b`
3. **Try it out**: Open a file, press `C-c a e` to explain code
4. **Explore**: Use `F7` for free-form questions
5. **Advanced**: Install aider for autonomous editing

Your Emacs is now a powerful AI-assisted development environment that works completely offline!

---

**Back to:** [Main README](README.md) | [Structure](README.md#structure) | [Installation](README.md#installation)
