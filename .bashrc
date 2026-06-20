# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

if command -v zsh >/dev/null 2>&1; then
  exec zsh
fi

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

. "$HOME/.local/share/../bin/env"

# Interactive Bash editing: autosuggestions and syntax highlighting.
if [[ -f "$HOME/.local/share/blesh/ble.sh" ]]; then
  source "$HOME/.local/share/blesh/ble.sh"
fi

# t-stream
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/home/levi/.cache/.bun/bin:$PATH"

ppm() {
  sudo /usr/local/bin/manual-power-mode "$@"
}

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
