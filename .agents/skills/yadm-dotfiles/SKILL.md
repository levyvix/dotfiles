---
name: yadm-dotfiles
description: Add, commit, and push dotfile changes with yadm to github.com:levyvix/dotfiles. Use when syncing config fixes to dotfiles, when the user asks to commit or push dotfiles, or when AGENTS.md requires yadm sync after a dotfile change.
---

# yadm dotfiles

Sync home-directory config changes to the dotfiles repo managed by **yadm**.

- **Remote:** `git@github.com:levyvix/dotfiles.git`
- **Branch:** `main`
- **Work tree:** `$HOME`
- **Git dir:** `$HOME/.local/share/yadm/repo.git`

## Agent skills layout

All personal skills live in **`~/.agents/skills/`** (read by Codex and Gemini). Other agents symlink here:

- `~/.cursor/skills` → Cursor
- `~/.claude/skills` → Claude Code
- `~/.codex/skills` → Codex (also reads `~/.agents/skills/` directly)
- `~/.gemini/skills` → Gemini
- `~/.opencode/skills` → OpenCode

Edit skills only under `~/.agents/skills/`.

## When to use

- User asks to commit, push, or sync dotfiles / yadm
- A config fix under `$HOME` should be persisted (per `AGENTS.md`)
- After editing tracked paths such as `~/.config/`, `~/.bashrc`, or agent skills under `~/.agents/skills/`

Only commit when the user asks, or when task context clearly requires syncing (e.g. "commit that to dotfiles").

Only push when the user asks, or when the task context implies it (e.g. fix is incomplete until pushed).

## Shell setup

Run all git/yadm commands from `$HOME` with:

```bash
export GIT_DIR="$HOME/.local/share/yadm/repo.git"
export GIT_WORK_TREE="$HOME"
```

If plain `yadm add` fails with "not a git repository", use `git` with those variables instead.

## Workflow

### 1. Scope the change

Stage **only** files related to the current fix. Do not sweep unrelated modified dotfiles.

Skip ephemeral/runtime files even inside config dirs:

- `*.log`, `*.sock`, `*.pid`, `*.lock`, `*.sqlite*`, `session.json`
- Secrets: `.env`, credentials, `~/.config/gh/hosts.yml`, `~/.config/zsh/secrets`

Respect `$HOME/.gitignore` (yadm's ignore rules).

### 2. Inspect (parallel)

```bash
cd "$HOME"
export GIT_DIR="$HOME/.local/share/yadm/repo.git" GIT_WORK_TREE="$HOME"
git status --short -- <paths>
git diff -- <paths>
git diff --cached -- <paths>
git log -5 --oneline
```

### 3. Stage

Prefer explicit paths over `git add -A`:

```bash
git add -- <path1> <path2>
```

Or, when `yadm` works:

```bash
yadm add -- <path1> <path2>
```

Review staged diff before committing:

```bash
git diff --cached
```

### 4. Commit

Use a short imperative subject (match recent style: "Add herdr config…", "Sync Waybar…").

```bash
git commit -m "$(cat <<'EOF'
Subject line describing why.

EOF
)"
```

- Never update git config
- Never skip hooks, force-push, or amend unless user rules allow
- Do not create empty commits

### 5. Push (when requested)

```bash
git push
```

Report the commit hash and remote branch after success.

## Examples

**Single config file after a fix:**

```bash
cd "$HOME"
export GIT_DIR="$HOME/.local/share/yadm/repo.git" GIT_WORK_TREE="$HOME"
git add -- .config/herdr/config.toml
git diff --cached
git commit -m "$(cat <<'EOF'
Add herdr alt keybindings for tabs and panes.

EOF
)"
git push   # only if user asked to push
```

**New or updated skill (canonical path; other agents symlink here):**

```bash
git add -- .agents/skills/yadm-dotfiles/SKILL.md
git add -- .cursor/skills .claude/skills .codex/skills .gemini/skills .opencode/skills   # symlinks, if newly created
```

**Whole config directory:** add only real config files, not logs/sockets:

```bash
git add -- .config/herdr/config.toml
# not: git add .config/herdr/  (would pick up ignored noise if rules change)
```

## Safety

- Warn before staging files that likely contain secrets
- Never force-push to `main` unless explicitly requested
- If commit fails on a hook, fix and create a **new** commit (do not amend a failed commit)
