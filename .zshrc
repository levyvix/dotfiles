. "$HOME/.local/bin/env"

export OPENCODE_EXPERIMENTAL_LSP_TOOL=true
export OPENCODE_EXPERIMENTAL=true
# Secrets sourced from untracked file (not committed)
[[ -r "$HOME/.config/zsh/secrets.zsh" ]] && source "$HOME/.config/zsh/secrets.zsh"

alias ani='ani-tupi anilist'
alias manga='manga-tupi anilist'

if [[ -r "$HOME/.config/zsh/.zshrc" ]]; then
  source "$HOME/.config/zsh/.zshrc"
fi

# >>> Codex installer >>>
export PATH="/home/levi/.local/bin:$PATH"
# <<< Codex installer <<<
