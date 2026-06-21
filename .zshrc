. "$HOME/.local/bin/env"

export OPENCODE_EXPERIMENTAL_LSP_TOOL=true
export OPENCODE_EXPERIMENTAL=true

if [[ -r "$HOME/.config/zsh/.zshrc" ]]; then
  source "$HOME/.config/zsh/.zshrc"
fi
