- ALWAYS use UV for running scripts and installed cli's. DON'T change pyproject.toml directly, USE uv add. For standalone isolated scripts you can use uv run --with <package> --with <package> script.py.
- DONT make summaries documents at the end of openspec changes.
- NEVER add "Generated with Claude Code" or "Co-Authored-By: Claude" footers to git commits.
- NEVER use `cat <<` for printing reports/summaries. Output text directly in your response instead.
- PREFER to use native bash tools (grep, fd, etc) commands to explore and discover.

### Web Information & Research (MCP - Use Proactively!)

**Always seek current information via MCP when relevant:**

- **Exa MCP** (`mcp__exa__*`): Use PROACTIVELY for up-to-date info
  - `web_search_exa` - Search for current best practices, documentation, tutorials
  - `crawling_exa` - Read full content from URLs (technical docs, articles, guides)
  - Use when researching: libraries, frameworks, technologies, current best practices
  - Prefer when: user asks "what's the latest", "best practices", "how to", documentation questions

- **Webclaw MCP** (`mcp__webclaw__*`): Use PROACTIVELY for content extraction
  - `scrape` - Extract single page content (markdown format)
  - `brand` - Extract visual identity (colors, fonts, logos)
  - `crawl` - Crawl websites for multi-page content
  - `extract` - Extract structured data with custom schemas
  - Use when: extracting specific data, understanding website structure, gathering current info

**When to use each:**

- **Always research**: Unfamiliar libraries, frameworks, APIs, tools
- **Always fetch**: Current documentation, tutorials, examples
- **Always check**: Best practices that may have changed
- **Proactive usage**: Don't wait for user to ask - fetch info if it would make your answer more accurate/current

**Example triggers:**

- User asks about a library → Search for current version & docs
- Implementing a pattern → Check for current best practices
- Using an API → Fetch latest documentation
- Recommending tools → Verify current state & features

### Code Intelligence

Prefer LSP over Grep/Read for code navigation — it's faster, precise, and avoids reading entire files:
- `workspaceSymbol` to find where something is defined
- `findReferences` to see all usages across the codebase
- `goToDefinition` / `goToImplementation` to jump to source
- `hover` for type info without reading the file

Use Grep only when LSP isn't available or for text/pattern searches (comments, strings, config).

After writing or editing code, check LSP diagnostics and fix errors before proceeding.

@RTK.md
