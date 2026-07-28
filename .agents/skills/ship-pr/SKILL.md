---
name: ship-pr
description: Open a pull request, monitor it until merge-ready, then squash-merge, delete the branch, and sync the local checkout. Handles worktree sessions, where the usual gh merge cleanup breaks.
---

# ship-pr

Open a PR, babysit it until merge-ready, then squash-merge, delete the branch, and sync local.

## When to use

- `ship-pr` — Open a PR and merge when ready
- User says "ship this", "open a PR and merge it"
- Wants a PR shepherded from creation through merge and cleanup

## Usage

```bash
/ship-pr
```

## Steps

1. **Check the ground.** `git status --short --branch`, `git remote -v`, `gh auth status`. Note whether you are in a worktree (`git worktree list` shows more than one entry, or the cwd is under `.claude/worktrees/`) — it changes step 5.
2. **Commit anything outstanding** and push with `-u` if the branch is new.
3. **Open the PR** with `gh pr create --base <default-branch> --head <branch>`. Body covers what changed and why, plus a test plan with checked items for what you actually ran and unchecked items for what you could not verify.
4. **Wait for checks.** `gh pr checks <n> --watch --interval 15`. Its summary can read as passing and pending at the same time, so always confirm with the authoritative field before merging:
   ```bash
   gh pr view <n> --json mergeable,mergeStateStatus -q '.'
   ```
   `CLEAN` means go. `UNSTABLE` means checks are still running or failing. `BLOCKED` means a review or a required check is missing — report and stop.
5. **Merge**, then delete the remote branch (see the worktree note below):
   ```bash
   gh pr merge <n> --squash
   git push origin --delete <branch>
   ```
6. **Verify the merge landed** before destroying anything local:
   ```bash
   gh pr view <n> --json state,mergedAt -q '.'
   ```
7. **Clean up and sync**, then re-run the project's build and tests on the synced default branch to confirm the squashed commit is sound.

## Inside a worktree

`gh pr merge --delete-branch` runs `git checkout <default-branch>` to clean up locally. When the default branch is already checked out in the primary worktree — which is the normal case for an `EnterWorktree` session — git refuses:

```
failed to run git: fatal: 'main' is already used by worktree at '/path/to/repo'
```

**The merge still succeeds server-side.** Only the local cleanup fails, and the error text makes it look like the whole command aborted. So:

- Do not pass `--delete-branch` when in a worktree. Run `gh pr merge <n> --squash`, then `git push origin --delete <branch>` explicitly.
- If you already ran it and hit this error, do not retry the merge. Check `gh pr view <n> --json state` first — a second merge attempt on a merged PR just adds noise.
- Confirm the remote branch is gone with `git ls-remote --heads origin`.

Order of teardown matters, because leaving the worktree discards its commits:

1. Confirm `state: MERGED` via `gh pr view`.
2. Leave the worktree with `ExitWorktree`. `action: "remove"` needs `discard_changes: true`, since the branch commits are not on the original branch from git's point of view — that is expected once the PR is squashed, and only safe because of step 1. Use `action: "keep"` if anything is uncommitted or unmerged.
3. Back in the primary checkout, `git pull --ff-only` and verify with `git worktree list` and `git log --oneline -3`.

## Report

Name the PR URL, the squashed commit sha, and the state of each cleanup step. Repeat any test-plan item that stayed unchecked and why — do not let a merge imply verification that never happened.
