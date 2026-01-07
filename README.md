# bb-emacs

Personal Emacs configuration for Brandon Barclay - A productivity-focused development environment emphasizing AI-assisted coding, visual comfort, and transparent configuration.

## Intent & Philosophy

This Emacs setup is designed around several core principles:

### Primary Goals

1. **AI-Augmented Development** - Deep integration with GitHub Copilot and LLM tools (gptel) for modern, AI-assisted coding workflows
2. **Python-Centric Polyglot Support** - Optimized for Python development with strong support for multiple languages (Lisp, JavaScript, C/C++, Java, Ruby, PHP, Shell, etc.)
3. **Visual Comfort** - Custom dark theme (#102e4e), rainbow delimiters, intelligent buffer grouping via tabbar
4. **Cross-Machine Portability** - Seamless synchronization across Mac and Linux systems
5. **Personal Productivity** - Org-mode integration, custom workflows, and historical computing artifacts (John McCarthy's facts library)

### Configuration Philosophy

- **Transparency over Abstraction** - Monolithic main configuration with targeted modular extensions
- **Manual Control** - AI assistance available on-demand rather than always-on
- **Performance Conscious** - Automatic byte-compilation, optimized startup
- **Simplicity** - No complex frameworks; direct, understandable configuration

## Key Features

### AI & Completion

- **GitHub Copilot** - Three-mode system (automatic/manual/off) with intelligent context awareness
  - `M-C-<escape>` - Cycle through activation modes
  - `M-C-<return>` - Trigger completions manually
  - `<tab>` - Accept completion
  - Automatically disabled in shells, REPLs, and minibuffers

- **gptel** - LLM integration with llama.cpp endpoints
  - `F7` - Send to LLM
  - Two configured endpoints: Tailscale remote (alvarez) and localhost
  - Crowdsourced prompt library included

- **Company** - Modern text completion framework

### Code Quality & Navigation

- **Flycheck** - Real-time syntax checking with isolated buffer grouping
- **EditorConfig** - Consistent coding styles across editors
- **Rainbow Delimiters** - 9-level color-coded parentheses for easier code reading
- **Hideshow** - Code folding with custom indentation support
  - `C-=` - Toggle current block
  - `M-=` - Toggle all blocks
  - `M-C-i` - Fold by indentation level

### Buffer & Window Management

- **Tabbar** - Intelligent buffer grouping by project/context
  - Groups: #flycheck, #misc, #site-emacs, $HOME, project-specific
  - `Shift-Arrow Keys` - Navigate tabs and groups

- **Winum** - Window numbering for quick navigation
  - Each window shows a number in the mode line
  - `M-1` through `M-9` to jump to specific windows instantly

- **Custom Frame Management** - Smart frame closing that works for parent/child frames
- **Change Tracking** - Visual highlighting of document changes
  - `F6` - Toggle change visibility
  - `Alt-PgUp/PgDn` - Navigate between changes

### Documentation & Writing

- **Org-mode** - Personal organization, agenda, capture, diary integration
  - Configured for Folsom, CA (calendar/astronomy)
  - `C-c a` - Agenda
  - `C-c c` - Capture
  - `C-c l` - Store link

- **Markdown** - Full editing and live preview support

### Development Workflow

- **Auto-chmod** - Scripts with shebang lines automatically become executable (750 permissions)
- **UTF-8 Everywhere** - Comprehensive UTF-8 configuration
- **Perforce Integration** - Version control support
- **Auto-compile** - Automatic Emacs Lisp compilation on load

### Key Bindings

#### Function Keys
| Key | Function |
|-----|----------|
| `F5` | Revert buffer |
| `F6` | Toggle change highlighting |
| `F7` | Send to gptel (LLM) |
| `F8` | Kill buffer |
| `Shift-F8` | Restore killed buffer |
| `F9` | Toggle line numbers |
| `F11` | Toggle fullscreen |

#### Navigation & Editing
| Key | Function |
|-----|----------|
| `%` | Jump to matching paren |
| `M-g` | Go to line |
| `M-1` to `M-9` | Jump to window 1-9 (winum) |
| `M-0` | Jump to window 10 or minibuffer |
| `Shift-Arrows` | Navigate tabbar tabs/groups |
| `C-=` | Toggle fold current block |
| `M-=` | Toggle fold all blocks |
| `M-C-i` | Fold by indentation level |
| `Alt-PgUp/PgDn` | Navigate between changes |

#### Projectile (Project Management) - `C-c p` prefix
| Key | Function |
|-----|----------|
| `C-c p f` | Find file in project (fuzzy search) |
| `C-c p p` | Switch to another project |
| `C-c p s g` | Grep/search in project |
| `C-c p r` | Find and replace in project |
| `C-c p k` | Kill all project buffers |
| `C-c p d` | Find directory in project |
| `C-c p !` | Run shell command in project root |
| `C-c p &` | Run async shell command in project root |

#### Copilot
| Key | Function |
|-----|----------|
| `M-C-<escape>` | Cycle copilot mode (auto/manual/off) |
| `M-C-<return>` | Trigger copilot completion manually |
| `<tab>` | Accept copilot completion |
| `M-C-<next>` | Next copilot suggestion |
| `M-C-<prior>` | Previous copilot suggestion |
| `M-C-<right>` | Accept completion by word |
| `M-C-<down>` | Accept completion by line |

#### Org-mode
| Key | Function |
|-----|----------|
| `C-c a` | Open org agenda |
| `C-c c` | Org capture |
| `C-c l` | Store org link |

#### AI Workflow (Claude Code Integration) - `C-c a` prefix
| Key | Function |
|-----|----------|
| `F7` | Send prompt to LLM with automatic context |
| `C-c a e` | Explain code (current region or function) |
| `C-c a t` | Generate tests for code |
| `C-c a r` | Refactor code with instructions |
| `C-c a p` | Send custom prompt with context |

## Claude Code Workflow Integration

The `bb-ai.el` module provides hooks and utilities designed to work seamlessly with Claude Code development workflows.

### Smart Context Gathering

When using AI assistance functions, the system automatically gathers:
- Current file path and major mode
- Selected region or function at point
- Project root and type (via projectile)
- Cursor position

### AI-Assisted Development Functions

**Explain Code** (`C-c a e`)
- Sends current region or function to LLM for explanation
- Automatically includes file and mode context
- Useful for understanding unfamiliar code

**Generate Tests** (`C-c a t`)
- Generates comprehensive tests for current function or selection
- Understands project context and testing frameworks
- Creates test structure matching your project conventions

**Refactor Code** (`C-c a r`)
- Prompts for refactoring instructions
- Sends code with full context to LLM
- Preserves functionality while improving code quality

**Smart LLM Prompt** (`F7` or `C-c a p`)
- Enhanced gptel integration with automatic context
- Includes file, mode, project, and selection information
- No need to manually paste code or explain context

### Workflow Hooks

The module provides hooks for custom integration:

```elisp
;; Pre-command hook (runs before AI operations)
bb-ai/pre-command-hook

;; Post-command hook (runs after AI operations)
bb-ai/post-command-hook

;; Example: Auto-save before AI operations
(add-hook 'bb-ai/pre-command-hook 'bb-ai/auto-save-buffer-maybe)
```

### Programming Mode Integration

AI assistance automatically activates in programming modes:
- Copilot enabled (if available)
- Context gathering ready
- Smart completions active

### Example Workflow

1. Open a Python file in your project
2. Select a function you want to test
3. Press `C-c a t` (generate tests)
4. LLM receives: file path, Python mode, project context, function code
5. Returns comprehensive test suite
6. Review and integrate tests

This eliminates manual context switching and copy-pasting when working with AI assistants.

## Structure

```
bb-emacs/
├── dot.emacs              # Main configuration (loads modules)
├── dot.emacs.backup       # Backup of previous monolithic config
├── early-init.el          # Startup optimization (GC tuning)
├── lisp/                  # Custom Emacs Lisp libraries (modular)
│   ├── bblib.el          # Core utility functions (frame, buffer, compilation)
│   ├── bb-core.el        # Core settings (theme, encoding, UI)
│   ├── bb-keybindings.el # All keybindings and interactive functions
│   ├── bb-coding.el      # Coding tools (flycheck, rainbow-delimiters, etc.)
│   ├── bb-completion.el  # Completion framework (auto-complete)
│   ├── bb-navigation.el  # Navigation (tabbar, projectile, winum, org)
│   ├── bb-ai.el          # AI assistance (copilot, gptel, Claude Code hooks)
│   ├── bb-copilot.el     # Copilot integration & modes
│   ├── bb-gptel.el       # LLM endpoint configuration
│   ├── tabbar-config.el  # Custom buffer grouping
│   ├── shebang.el        # Auto chmod for scripts
│   └── facts.el          # John McCarthy's astronomical calculator
├── melpa-packages/        # MELPA package installations
├── copilot.el/           # GitHub Copilot (git submodule)
├── ac-dict/              # Auto-complete dictionaries
└── fonts/                # Inconsolata font variants
```

### Modular Architecture

The configuration is now organized by function:

- **bb-core.el** - Basic Emacs behavior, theme, encoding, UI settings
- **bb-keybindings.el** - All global keybindings and custom interactive functions
- **bb-coding.el** - Development tools (syntax checking, formatting, code folding)
- **bb-completion.el** - Text completion framework
- **bb-navigation.el** - Buffer/window/project navigation tools
- **bb-ai.el** - AI-assisted development with Claude Code workflow hooks

This makes it easy to:
- Test individual components
- Share specific configurations
- Understand what each module provides
- Selectively enable/disable features

## Installation

### Prerequisites

- Emacs 27+ (Emacs 28+ recommended for native compilation)
- Git
- Inconsolata font (included in `/fonts` or install system-wide)

### Setup

```bash
# Clone repository
git clone <repository-url> ~/.emacs.d
cd ~/.emacs.d

# Initialize submodules (for copilot.el)
git submodule update --init --recursive

# Symlink or copy dot.emacs as init.el
ln -s ~/.emacs.d/dot.emacs ~/.emacs.d/init.el

# Start Emacs - packages will auto-install from MELPA
emacs
```

### Font Installation

**Linux:**
```bash
mkdir -p ~/.fonts
cp fonts/Inconsolata.otf ~/.fonts/
fc-cache -f -v
```

**macOS:**
```bash
cp fonts/Inconsolata.otf ~/Library/Fonts/
```

## Platform-Specific Notes

### macOS
- Option key → Super modifier
- Command key → Meta modifier
- Calendar configured for Folsom, CA coordinates

### Linux
- Standard modifier key mapping
- Requires Inconsolata font in `~/.fonts/`

## Customization

### Adding Language Support

Edit `dot.emacs` to add mode hooks:
```elisp
(add-hook 'your-mode-hook 'hs-minor-mode)  ; Enable code folding
```

### Configuring gptel Endpoints

Edit `/lisp/bb-gptel.el`:
```elisp
(gptel-make-openai "my-endpoint"
  :stream t
  :protocol "http"
  :host "your-host:port"
  :models '("your-model"))
```

### Customizing Tabbar Groups

Edit `/lisp/tabbar-config.el` to modify buffer grouping logic.

## Notable Components

### John McCarthy's Facts Library

A 344-line scientific calculator (`facts.el`) containing physical constants, unit conversions, and astronomical data. Originally created by John McCarthy (Lisp inventor) for calculations about "moving Mars to a more temperate location."

### Three-Mode Copilot Integration

Advanced activation system balancing automatic assistance with manual control:
- **Automatic** - Overlays appear automatically (productivity mode)
- **Manual** - Trigger completions with `M-C-<return>` (learning mode)
- **Off** - Completely disabled (focus mode)

## Performance

- Startup time: <1 second with optimizations
- Early GC tuning prevents startup slowdown
- Lazy package loading reduces initial memory footprint
- Byte-compilation ensures fast library loading

## Dependencies

### Core Packages (auto-installed from MELPA)

- `use-package` - Declarative package configuration
- `flycheck` - Syntax checking
- `auto-complete` - Completion framework with custom dictionaries
- `tabbar` - Buffer tabs with custom grouping
- `winum` - Window numbering (M-1 to M-9 for quick window jumping)
- `rainbow-delimiters` - Paren highlighting
- `projectile` - Project management and navigation
- `gptel` - LLM integration
- `org-modern` - Modern org-mode styling
- `markdown-mode` - Markdown support
- `yaml-mode` - YAML support
- `editorconfig` - Cross-editor consistency
- `auto-compile` - Automatic Elisp compilation
- `copilot` - GitHub Copilot (via submodule)

## Development

### Git Workflow

This configuration syncs automatically across multiple machines (visible in commit history). Changes are merged from various hosts:
- bb@macbook-pro.fiordland-tailor.ts.net
- bb@Brandons-MacBook-Pro.local

### Recent Evolution

Recent commits show progression toward AI-augmented workflows:
- gptel LLM integration
- Flycheck error isolation in tabbar
- John McCarthy facts library
- Column number display
- Shebang auto-chmod

## License

Personal configuration - use and adapt as needed.

## Acknowledgments

- John McCarthy for the facts library
- Robert Krahn for Copilot integration patterns
- The Emacs and MELPA communities
