# OpenCode Setup

This directory contains the OpenCode configuration for this repository. It works
alongside the existing `.claude/` Claude Code setup. Copy `opencode.json` and this
`.opencode/` directory into your project to use OpenCode here.

## Structure

| Path | Purpose |
|------|---------|
| `AGENTS.md` | OpenCode-specific project guidelines (system prompt) |
| `skills/` | OpenCode-specific skills (optional; shares `.claude/skills/`) |

## Configuration

Root-level OpenCode settings live in `opencode.json` at the repository root:

```json
{
  "settings": {
    "theme": "default",
    "defaultModel": "{env:OPENCODE_DEFAULT_MODEL}"
  },
  "mcp": {
    "servers": {}
  },
  "permissions": {
    "allow": [],
    "deny": []
  }
}
```

## Installed Plugins, Skills, and MCPs

OpenCode reuses the Claude Code installation under `.claude/`:

### Plugins (from `.claude/plugins/`)

| Plugin | Source | Version |
|--------|--------|---------|
| `context7@claude-plugins-official` | github:anthropics/claude-plugins-official | `1dd995193ba2` |
| `playwright@claude-plugins-official` | github:anthropics/claude-plugins-official | `1dd995193ba2` |
| `valtown@claude-plugins-official` | github:anthropics/claude-plugins-official | `0.4.0` |

Enabled in Claude Code `settings.json`: `context7`, `playwright`.

### Skills (from `.claude/skills/`)

28 skills are available and shared between Claude Code and OpenCode. Each skill's
`SKILL.md` declares its name, description, and trigger conditions. Full list is in
`.claude/README.md` under "Installed Skills".

Notable skills available in `.claude/skills/`:
- `modern-web-guidance` — mandatory first step for HTML/CSS/JS tasks
- `ui-typography` — enforces typographic correctness on all UI text
- `human-architect-mindset` — architectural thinking before implementation
- `vanity-engineering-review` — over-engineering detection
- `a11y-debugging` — accessibility auditing via Chrome DevTools MCP
- `chrome-devtools`, `debug-optimize-lcp`, `troubleshooting` — browser debugging
- `memory-leak-debugging` — JS/Node memory leak diagnosis
- `seo-audit` — technical SEO diagnosis
- `permissioned-github` — GitHub interaction with permission gates

### MCP Servers

The `mcp/` directory under `.claude/` is a placeholder for Model Context Protocol
server configurations. No MCP servers are currently configured. Add server definitions
to `opencode.json` under `mcp.servers` as needed:

```json
"mcp": {
  "servers": {
    "example": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-example"]
    }
  }
}
```

## Usage

1. Copy `opencode.json.example` to `opencode.json` locally (never committed), and copy the `.opencode/` directory to your project.
2. Set required environment variables — never commit secrets:
   - `OPENCODE_DEFAULT_MODEL` — the model to use (e.g. `claude-opus-5`)
3. Configure MCP servers in `opencode.json` as needed.
4. Load skills via the `skill` tool before starting related work.

## Secret Handling

- Do not hardcode model API keys, tokens, or credentials in `opencode.json`.
- Use `{env:VAR}` or `{file:path}` substitutions so each environment supplies its own values.
- Local OpenCode cache/data/env/secrets files are excluded via the root `.gitignore`.
