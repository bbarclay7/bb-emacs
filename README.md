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

| Key | Function |
|-----|----------|
| `F5` | Revert buffer |
| `F6` | Toggle change highlighting |
| `F7` | Send to gptel (LLM) |
| `F8` | Kill buffer |
| `Shift-F8` | Restore killed buffer |
| `F9` | Toggle line numbers |
| `F11` | Toggle fullscreen |
| `%` | Jump to matching paren |
| `M-g` | Go to line |
| `Shift-Arrows` | Navigate tabbar tabs/groups |

## Structure

```
bb-emacs/
├── dot.emacs              # Main configuration file
├── early-init.el          # Startup optimization (GC tuning)
├── lisp/                  # Custom Emacs Lisp libraries
│   ├── bblib.el          # Core utility functions
│   ├── bb-copilot.el     # Copilot integration & modes
│   ├── bb-gptel.el       # LLM configuration
│   ├── tabbar-config.el  # Custom buffer grouping
│   ├── shebang.el        # Auto chmod for scripts
│   └── facts.el          # John McCarthy's astronomical calculator
├── melpa-packages/        # MELPA package installations
├── copilot.el/           # GitHub Copilot (git submodule)
├── ac-dict/              # Auto-complete dictionaries
└── fonts/                # Inconsolata font variants
```

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
- `company` - Completion framework
- `tabbar` - Buffer tabs
- `rainbow-delimiters` - Paren highlighting
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
