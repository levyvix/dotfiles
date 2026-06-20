## Dotfiles Sync Preference

When a dotfile modification helps fix the problem I am having, sync that change to my dotfiles repository using `yadm`.

Rules:
- Treat the fix as incomplete until the relevant dotfile changes are committed in `yadm`.
- Stage and sync only the files related to the fix, not unrelated modified dotfiles.
- If the task context implies syncing, push the resulting `yadm` commit too.
