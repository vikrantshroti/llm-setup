# LLM Setup Repository

This repository contains the complete Claude Code setup that can be replicated for any LLM (Claude, Gemini, Codex, etc.).

## Structure

- `.claude/` - Claude Code configuration directory
  - `skills/` - Custom skills for extending functionality
  - `mcp/` - Model Context Protocol server configurations
  - `agents/` - Custom agent definitions
  - `settings.json` - Main configuration file
  - `CLAUDE.md` - Project-specific guidelines

## Purpose

This setup allows any LLM to have the same capabilities as Claude Code by providing:
- Skill system for extending functionality
- MCP server integration for external tools
- Agent system for specialized tasks
- Configuration management
- Prompt templates and utilities

## Usage

1. Copy the `.claude/` directory to your project
2. Configure your LLM to use the skills and agents
3. Set up MCP servers as needed
4. Customize settings.json for your specific LLM

## License

MIT
