# OpenCode Project Guidelines

This file governs OpenCode behavior in this repository. It complements the existing
`.claude/CLAUDE.md` Claude Code guidelines.

## Core Principles

- Prefer simple, readable, maintainable code over cleverness.
- Never commit secrets, API keys, or credentials. Use `{env:VAR}` or `{file:path}`
  substitutions in `opencode.json` instead of hardcoding values.
- All AI contributions require human review and version-control traceability.
- Make the smallest reasonable change to achieve the goal.

## Skill Discovery

OpenCode skills live in `.claude/skills/` (shared with Claude Code) and can also be
added under `.opencode/skills/` for OpenCode-specific skills. Load skills via the
`skill` tool before starting related work.

## Secret Handling

- Do not hardcode model API keys, tokens, or credentials in `opencode.json`.
- Reference them with `{env:OPENCODE_*}` so each environment supplies its own values.
- Never commit `.opencode/` files that contain resolved secrets.
