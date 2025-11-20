# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains reusable Claude Code plugins distributed via the Claude Code Plugin Marketplace. Currently, it hosts the **Jujutsu VCS Plugin**, which provides SessionStart hook integration to remind Claude to use `jj` commands in Jujutsu repositories.

### Architecture

The repository structure is organized around individual plugins:

```
jujutsu-vcs/
├── .claude-plugin/plugin.json      # Plugin metadata
├── hooks/hooks.json                # Hook definitions (SessionStart)
├── hooks-handlers/                 # Bash scripts that execute hooks
│   └── jujutsu-reminder.sh        # Outputs context reminder for jj usage
├── docs/decisions/                 # Architectural decision records (ADRs)
└── README.md                       # Plugin-specific documentation
```

### Plugin Distribution

Plugins are exposed via `marketplace.json` at the repository root. Each plugin:

1. Is self-contained in its own directory
2. Has a `plugin.json` metadata file
3. Implements hooks or skills that Claude Code can use
4. Includes documentation for users

### The Jujutsu VCS Plugin

**Key Decision**: Uses **hooks over skills** for reliable VCS integration (see `jujutsu-vcs/docs/decisions/01-use-hooks-over-skills-for-jujutsu-vcs.md`).

**Why hooks?** LLMs have no persistent memory—they work with context. Hooks inject context at session start (guaranteed visible), while skills require the LLM to remember to invoke them mid-task. For critical operations like VCS, hooks are more reliable.

**Hook Type**: SessionStart
**Handler**: Bash script (`jujutsu-reminder.sh`)
**Smart Activation**: Only injects context when `.jj/` directory exists (Jujutsu repository detection)

## Developing Plugins

### Adding a New Plugin

1. Create a directory under the repository root (e.g., `new-plugin/`)
2. Create required structure:
   ```
   new-plugin/
   ├── .claude-plugin/plugin.json
   ├── hooks/hooks.json (if using hooks)
   ├── skills/ (if using skills)
   └── README.md
   ```
3. Add plugin entry to `/.claude-plugin/marketplace.json`
4. Update root `README.md` with plugin description

### Hook Script Guidelines

Hook handler scripts (in `hooks-handlers/`) should:

- Output JSON with the structure: `{ "hookSpecificOutput": { "hookEventName": "...", "additionalContext": "..." } }`
- Include repository detection when appropriate (check for `.jj/`, `.git/`, etc.)
- Exit with code 0 on success (silent on non-applicable repositories)
- Use bash for compatibility

### Metadata Files

- **`plugin.json`**: Contains name, description, version, author, keywords, license, repository URL
- **`hooks.json`**: Defines hooks and their handlers (command, condition, etc.)
- **`marketplace.json`** (root): Lists all plugins available for distribution

## Common Development Patterns

### Testing Plugins Locally

1. Add local marketplace: `/plugin marketplace add ./`
2. Install from local: `/plugin install jujutsu-vcs@claude-code-plugins`
3. Verify hook activation: Start a new session and check for context injection

### Documentation

- Each plugin has its own `README.md` explaining features, installation, and usage
- Architectural decisions go in `docs/decisions/` with ADR format
- Root `README.md` provides overview of all plugins

## Commit Message Style

Keep commit messages concise and focus on **what** was done, not **how**:

- ✓ `fix: manifest error`
- ✗ `Fixed the manifest by updating the JSON structure and removing duplicate keys`

Use conventional commit prefixes: `feat:`, `fix:`, `docs:`, `refactor:`, etc.
