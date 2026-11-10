# Claude Code Setup

This directory contains the complete Claude Code configuration that can be replicated
for any LLM (Claude, Gemini, Codex, etc.). Copy this `.claude/` directory into your
project to give your LLM Claude Code–level capabilities.

## Structure

| Path | Purpose |
|------|---------|
| `skills/` | Custom skills for extending functionality (28 skills installed) |
| `mcp/` | Model Context Protocol server configurations (placeholder) |
| `agents/` | Custom agent definitions for specialized tasks (placeholder) |
| `settings.json` | Main configuration file |
| `CLAUDE.md` | Project-specific guidelines / system prompt |
| `statusline.sh` | Bash status-line script rendering model, git, context, cost, rate limits |
| `mcp-needs-auth-cache.json` | Empty auth-cache placeholder for MCP servers |
| `plugins/` | Plugin catalog/cache for official Claude plugins |

## Installed Plugins

| Plugin | Source | Version | Enabled |
|--------|--------|---------|---------|
| `context7@claude-plugins-official` | github:anthropics/claude-plugins-official | `1dd995193ba2` | yes |
| `playwright@claude-plugins-official` | github:anthropics/claude-plugins-official | `1dd995193ba2` | yes |
| `valtown@claude-plugins-official` | github:anthropics/claude-plugins-official | `0.4.0` | no |

Enabled plugins are declared in `settings.json` under `enabledPlugins`. The full install
record is in `plugins/installed_plugins.json`; the known marketplace is in
`plugins/known_marketplaces.json`.

## Installed Skills

28 skills live in `skills/`. Each skill has a `SKILL.md` with front-matter declaring its
name, description, and trigger conditions so the LLM knows when to load it.

| Skill | Purpose |
|-------|---------|
| `a11y-debugging` | Chrome DevTools MCP accessibility debugging/auditing per web.dev |
| `adaptive-communication` | Detects ambiguous intent and clarifies before acting |
| `agentic-ux-design-relationship-centric-interfaces` | AI-first interfaces with memory, trust, collaboration |
| `chrome-devtools` | Chrome DevTools MCP debugging, automation, performance |
| `chrome-extensions` | Build/publish Chrome Extensions (Manifest V3) |
| `debug-optimize-lcp` | LCP / Core Web Vitals optimization via Chrome DevTools MCP |
| `design-audit` | Premium UI/UX audit and refinement |
| `enhance-prompt` | Polishes vague UI ideas into Stitch-optimized prompts |
| `find-skills` | Discovers and installs agent skills |
| `frontend-design` | Production-grade frontend interfaces |
| `generative_ui` | Rich interactive HTML widgets (diagrams, controls, walkthroughs) |
| `human-architect-mindset` | Systematic architectural thinking for complex decisions |
| `memory-leak-debugging` | JS/Node memory leak diagnosis (memlab, heapsnapshots) |
| `migrate-workflows` | Migrates legacy workflows to modern skills |
| `modern-web-guidance` | Mandatory first-step search for HTML/CSS/JS best practices |
| `negentropy-lens` | Entropy vs negentropy decision-support for architecture |
| `organic-first-campaign` | Grassroots campaign design for low-budget competition |
| `permissioned-github` | GitHub interaction guidelines with permission gates |
| `renaissance-architecture` | First-principles software architecture and UI/UX |
| `seo-audit` | Technical SEO diagnosis and audit |
| `troubleshooting` | Chrome DevTools MCP connection/target troubleshooting |
| `ui-typography` | Professional typography rules for UI text |
| `using-superpowers` | Requires skill invocation before any response |
| `vanity-engineering-review` | Reviews for vanity/over-engineering |
| `vercel-composition-patterns` | Scalable React composition patterns |
| `vercel-react-best-practices` | React/Next.js performance optimization |
| `vercel-react-native-skills` | React Native / Expo best practices |
| `vercel-react-view-transitions` | React View Transition API animations |
| `web-design-guidelines` | Web Interface Guidelines compliance review |

## Usage

1. Copy the `.claude/` directory to your project.
2. Configure your LLM to use the skills and agents.
3. Set up MCP servers as needed in `mcp/`.
4. Customize `settings.json` for your specific LLM.

## Secret Handling

- Never commit secrets, API keys, or credentials.
- Reference runtime values via `{env:VAR}` or `{file:path}` substitutions.
- Local plugin caches and auth files are excluded via `.gitignore`.
