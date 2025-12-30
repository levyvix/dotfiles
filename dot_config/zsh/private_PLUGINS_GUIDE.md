# ZSH Plugins Setup Guide

## Installed Plugins

This ZSH configuration includes three powerful plugins for an enhanced shell experience:

### 1. **zsh-autosuggestions**
- **Location**: `~/projects/zsh-plugins/zsh-autosuggestions/`
- **What it does**: Suggests commands from your history as you type (like Fish shell)
- **How to use**:
  - Start typing a command
  - Press `Ctrl+Space` to accept the suggestion
  - Press `→` (right arrow) to accept part of the suggestion
  - Press `Escape` to dismiss the suggestion

### 2. **fzf-tab**
- **Location**: `~/projects/zsh-plugins/fzf-tab/`
- **What it does**: Replaces ZSH's default completion menu with an interactive fuzzy-searchable menu
- **How to use**:
  - Press `TAB` after a partial command to open the fuzzy completion menu
  - Type to search through options
  - Use arrow keys or `Ctrl+N`/`Ctrl+P` to navigate
  - Press `Enter` to select
  - Works with: git commands, npm/yarn, docker, files, directories, etc.
- **Example**: `git ch<TAB>` → shows all git branches starting with "ch"

### 3. **zsh-syntax-highlighting**
- **Location**: `~/projects/zsh-plugins/zsh-syntax-highlighting/`
- **What it does**: Real-time syntax highlighting as you type
- **How to use**:
  - Just type! Commands are highlighted as:
    - **Green**: Valid command
    - **Red**: Invalid/misspelled command
    - **Cyan**: Alias
    - **Yellow**: Arguments/parameters
    - **Magenta**: History expansion
- **Example**: Type `ccd /tmp` and see that "ccd" appears red (invalid)

## Testing the Plugins

### Quick Test Commands

1. **Test syntax highlighting**:
   ```bash
   # Type an invalid command and watch it turn red
   cdd /tmp

   # Type a valid command and watch it turn green
   cd /tmp
   ```

2. **Test autosuggestions**:
   ```bash
   # Start typing a previous command
   git  # Wait a moment, you'll see a suggestion appear
   # Press Ctrl+Space or → to accept it
   ```

3. **Test fzf-tab**:
   ```bash
   # Git completion
   git che<TAB>  # Shows git branches starting with "che"

   # File completion
   ls /us<TAB>   # Shows directories in /

   # Command completion
   docker run<TAB>  # Shows docker run options
   ```

## Performance

- **Startup time**: ~100-150ms (minimal overhead)
- **Memory**: Minimal (plugins are lightweight)
- **Dependencies**:
  - `fzf` (0.67.0) - Already installed ✓
  - `bat` (0.26.0) - Already installed ✓ (used for better previews)

## Customization

Edit `~/.config/zsh/plugins` to customize:

- **zsh-autosuggestions**: Change color, strategy, key bindings
- **fzf-tab**: Adjust preview style, menu colors, search behavior
- **zsh-syntax-highlighting**: Modify color scheme, enabled highlighters

## Troubleshooting

### Plugins not loading?
```bash
# Check if the plugin files exist
ls -la ~/projects/zsh-plugins/

# Reload your shell
exec zsh
```

### Completion menu not showing?
```bash
# Verify fzf is installed
which fzf

# Re-source the plugins configuration
source ~/.config/zsh/plugins
```

### Syntax highlighting not working?
```bash
# Make sure zsh-syntax-highlighting is sourced LAST
# Check the order in ~/.config/zsh/plugins

# Restart shell
exec zsh
```

### Slow startup?
```bash
# Time your shell startup
time zsh -i -c exit

# Should be <200ms. If slower, check what's taking time:
zsh -x -i -c exit 2>&1 | tail -50
```

## Key Bindings Reference

| Binding | Plugin | Action |
|---------|--------|--------|
| `TAB` | fzf-tab | Open interactive completion menu |
| `Ctrl+Space` | zsh-autosuggestions | Accept suggestion |
| `→` (Right Arrow) | zsh-autosuggestions | Accept suggestion partially |
| `Escape` | zsh-autosuggestions | Dismiss suggestion |
| `Ctrl+R` | Atuin (if installed) | Search history |

## Advanced Features

### Preview Functionality
fzf-tab can preview files and directories:
```bash
# The preview is automatically shown for file completions
ls /etc/<TAB>  # Shows file preview using bat
```

### Custom Completion Colors
Edit `~/.config/zsh/plugins` to change colors:
```bash
# Change fzf-tab colors
zstyle ':fzf-tab:*' fzf-flags --color=...
```

## Related Tools

Your setup integrates with:
- **Starship**: Modern prompt (already configured)
- **Zoxide**: Smart directory jumping (`z` command)
- **Fzf**: Fuzzy finder (used by fzf-tab)
- **Omarchy**: Collection of aliases and functions

## Update Instructions

To update plugins to the latest version:
```bash
cd ~/projects/zsh-plugins/fzf-tab && git pull
cd ~/projects/zsh-plugins/zsh-autosuggestions && git pull
cd ~/projects/zsh-plugins/zsh-syntax-highlighting && git pull
```

---

**Last Updated**: 2025-11-22
**ZSH Version**: 5.9
**Plugin Manager**: Manual (git-based)
