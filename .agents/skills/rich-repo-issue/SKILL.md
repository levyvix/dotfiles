---
name: rich-repo-issue
description: Create rich, well-scoped repository issues from a feature or bug description and publish them with the correct forge CLI. Use when the user wants Codex to turn an implementation idea, bug report, or vague change request into a complete GitHub or GitLab issue; when Codex should interrogate requirements with grill-me, inspect the codebase for affected areas or inconsistencies, and then open the issue with gh or glab based on the repository remote.
---

# Rich Repo Issue

Turn a rough feature or bug description into a publishable issue with enough context for another engineer to execute it without re-discovering the problem.

## Workflow

1. Read and use the local `grill-me` skill first.
   Use `/home/levi/.agents/skills/grill-me/SKILL.md`.
   Ask one question at a time when a question is still necessary.
   If a question can be answered from the repository, inspect the repository instead of asking.

2. Build context before drafting.
   Check the repository remote with `rtk git remote get-url origin`.
   Inspect existing issue templates before drafting:
   - GitHub: `.github/ISSUE_TEMPLATE/`, `.github/ISSUE_TEMPLATE.md`, `.github/ISSUE_TEMPLATE.yml`, `.github/ISSUE_TEMPLATE/config.yml`
   - GitLab: `.gitlab/issue_templates/`
   Inspect the code paths, tests, docs, and config that are likely affected.
   Look for inconsistencies between the user request and the current implementation.

3. Collect the minimum complete issue payload.
   Capture:
   - problem or opportunity
   - current behavior
   - desired behavior
   - why the change matters
   - scope boundaries
   - affected modules, commands, or files
   - acceptance criteria
   - reproduction steps for bugs
   - risks, edge cases, and unknowns
   - suggested labels or issue type if the repository uses them

4. Draft the issue body using the reference template in `references/issue-template.md`.
   Prefer repository-native sections if an issue template exists.
   Keep the title concrete and implementation-oriented.
   Include file paths and commands when they materially reduce ambiguity.
   Do not pad the issue with generic project-management filler.

5. Publish with the correct CLI.
   Use `scripts/create_issue.py`.
   The script detects GitHub vs GitLab from `origin`.
   For GitHub it uses `gh issue create`.
   For GitLab it uses `glab issue create`.
   If the required CLI is missing, stop and report exactly what is missing.

## Title Rules

- Start with the user-facing problem or capability, not the implementation detail.
- Prefer imperative or result-focused titles.
- Good: `Add season-aware continue flow to anime playback history`
- Good: `Fix duplicate search results when titles differ only by dubbed suffix`
- Bad: `Improve code`
- Bad: `Refactor service`

## Investigation Rules

- Prefer repository evidence over assumptions.
- Quote only short, decisive snippets from code or templates when needed.
- Mention specific files only when they clarify ownership or scope.
- If the repo already has conventions for labels, milestones, or issue structure, follow them.
- If the user request conflicts with current code or product behavior, surface that conflict in the issue body.

## Publishing Rules

- If the user explicitly asked to create/open the issue, publish it after the investigation and drafting are complete.
- If the user only asked for a draft, stop before publishing and return the draft.
- After publishing, report the issue URL or identifier back to the user.

## Resources

- `references/issue-template.md`: default structure for rich issues when the repo does not provide one.
- `scripts/create_issue.py`: detect forge and open the issue with `gh` or `glab`.
