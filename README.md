# LLM Setup Repository

This repository contains a replicable LLM setup that works with both **Claude Code**
and **OpenCode**. It provides skills, MCP server configuration, agent definitions,
settings, and guidelines so any LLM can operate with Claude Code–level capabilities.

## Structure

| Path | Purpose |
|------|---------|
| `.claude/` | Claude Code configuration directory |
| `.opencode/` | OpenCode configuration directory |
| `opencode.json.example` | Example OpenCode config (copy to `opencode.json` locally) |

## Sub-projects

- **[Claude Code Setup →](.claude/README.md)** — skills, plugins, settings, `CLAUDE.md` guidelines, status line
- **[OpenCode Setup →](.opencode/README.md)** — OpenCode guidelines, plugin/skill/MCP inventory, env var requirements

## Usage

### Claude Code

1. Copy the `.claude/` directory to your project.
2. Configure your LLM to use the skills and agents.
3. Set up MCP servers as needed.
4. Customize `.claude/settings.json` for your specific LLM.

### OpenCode

1. Copy `opencode.json.example` to `opencode.json` (locally, never committed).
2. Copy the `.opencode/` directory to your project.
3. Set required environment variables — never commit secrets:
   - `OPENCODE_DEFAULT_MODEL` — the model to use
4. Configure MCP servers in `opencode.json` as needed.
5. Load skills via the `skill` tool before starting related work.

## Secret Handling

- Never commit secrets, API keys, or credentials.
- Reference runtime values via `{env:VAR}` or `{file:path}` substitutions.
- `opencode.json` (with resolved values) is gitignored; only `opencode.json.example` is tracked.

## License

MIT
