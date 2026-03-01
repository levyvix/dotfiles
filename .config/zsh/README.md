# ZSH Configuration with Akita's omarchy-zsh

This is a modern, minimal ZSH configuration based on Akita's omarchy-zsh framework, enhanced with three industry-standard plugins.

## Quick Start

```bash
# Reload your shell
exec zsh

# Test fzf-tab completion
git che<TAB>

# Test autosuggestions  
git pu  # Wait, then Ctrl+Space to accept

# Test syntax highlighting
cdd /tmp  # Appears RED (invalid)
cd /tmp   # Appears GREEN (valid)
```

## Three Plugins Installed

### 1. fzf-tab - Interactive Autocompletion
- **Location**: `~/projects/zsh-plugins/fzf-tab/`
- **Use**: Press `TAB` for fuzzy-searchable completion menu
- **Features**: Live preview with bat, works everywhere

### 2. zsh-autosuggestions - Smart History Suggestions
- **Location**: `~/projects/zsh-plugins/zsh-autosuggestions/`
- **Use**: Types as you type (Fish-like experience)
- **Accept with**: `Ctrl+Space` or `→`

### 3. zsh-syntax-highlighting - Real-Time Color Feedback
- **Location**: `~/projects/zsh-plugins/zsh-syntax-highlighting/`
- **Colors**: Green (valid), Red (invalid), Cyan (alias), Yellow (args)
- **Use**: Automatic - just type!

## Configuration Files

```
~/.config/zsh/
├── .zshrc              # Main entry point
├── shell               # History and keybindings
├── init                # Tool initializations
├── envs                # Environment variables
├── aliases             # Command shortcuts
├── prompt              # Starship prompt
├── plugins             # Plugin config ← PLUGINS HERE
├── secrets             # API keys (gitignored)
├── PLUGINS_GUIDE.md    # Detailed plugin guide
└── README.md           # This file
```

## Documentation

- **Full Plugin Guide**: `~/.config/zsh/PLUGINS_GUIDE.md`
- **Installation Summary**: `~/ZSH_PLUGINS_INSTALLATION_SUMMARY.md`
- **Backup Location**: `~/shell-config-backup-20251122-214842/`

## Keyboard Shortcuts

| Binding | Plugin | Action |
|---------|--------|--------|
| `TAB` | fzf-tab | Open completion menu |
| `Ctrl+Space` | zsh-autosuggestions | Accept suggestion |
| `→` | zsh-autosuggestions | Accept suggestion |
| `Ctrl+R` | fzf | Search history |

## Performance

- Startup: ~150ms
- Memory: ~2-3MB overhead
- Completion: <50ms

## Updates

Update all plugins:
```bash
cd ~/projects/zsh-plugins
for dir in */; do (cd "$dir" && git pull); done
```

## Troubleshooting

```bash
# Syntax check
zsh -n ~/.zshrc

# Reload
exec zsh

# Debug startup
zsh -x -i -c exit 2>&1 | tail -50
```

See `PLUGINS_GUIDE.md` for detailed help.

---
Last updated: 2025-11-22
