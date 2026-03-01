- always use UV for running scripts and installed cli's. DON'T change pyproject.toml directly, USE uv add. for standalone isolated scripts you can use uv run --with <package> --with <package> script.py, but document this command somewhere close to the script (maybe inside or readme in folder)
- dont make summaries documents at the end of openspec changes.
- NEVER add "Generated with Claude Code" or "Co-Authored-By: Claude" footers to git commits.
- NEVER use `cat <<` for printing reports/summaries. Output text directly in your response instead.

### Code Intelligence

Prefer LSP over Grep/Read for code navigation — it's faster, precise, and avoids reading entire files:
- `workspaceSymbol` to find where something is defined
- `findReferences` to see all usages across the codebase
- `goToDefinition` / `goToImplementation` to jump to source
- `hover` for type info without reading the file

Use Grep only when LSP isn't available or for text/pattern searches (comments, strings, config).

After writing or editing code, check LSP diagnostics and fix errors before proceeding.
