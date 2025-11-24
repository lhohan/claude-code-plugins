# AGENTS.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains reusable Claude Code plugins distributed via the **hanlho-plugins** marketplace. The collection is geared towards architecture, code quality, and development workflow automation.

### Current Plugins

1. **jujutsu-vcs** - SessionStart hook for Jujutsu VCS integration
2. **skill-evaluator** - Skill for evaluating Claude Code skills against best practices
3. **hanlho-cmds** - Collection of productivity commands for workflow automation

### Plugin Types by Capability

Claude Code plugins can implement four capability types:

#### Hooks
Automatically execute at lifecycle events (e.g., SessionStart) to inject context.

**Example: jujutsu-vcs**
```
jujutsu-vcs/
├── .claude-plugin/plugin.json
├── hooks/hooks.json
├── hooks-handlers/jujutsu-reminder.sh
├── docs/decisions/
└── README.md
```

**Use case**: Guaranteed context injection for critical operations (VCS reminders, security guidelines).

#### Skills
LLM-invoked specialized capabilities for on-demand expertise.

**Example: skill-evaluator**
```
skill-evaluator/
├── .claude-plugin/plugin.json
├── skills/skill-evaluator/SKILL.md
├── references/EXAMPLE.md
└── README.md
```

**Use case**: Optional, specialized capabilities requiring LLM judgment to activate.

#### Commands (Slash Commands)
User-triggered workflows via `/plugin-name:command-name` syntax.

**Example: hanlho-cmds**
```
hanlho-cmds/
├── .claude-plugin/plugin.json
├── commands/bbh.md
└── README.md
```

**Use case**: Frequently used workflow shortcuts, prompt templates, multi-step procedures.

#### Agents
Specialized expert personas for task delegation (not yet used in this repository).

**Structure**: `agents/<agent-name>.md` with frontmatter defining role, expertise, and model preference.

**Use case**: Domain-specific expert roles for complex subagent workflows.

### Plugin Distribution

Plugins are exposed via `.claude-plugin/marketplace.json` at the repository root. Each plugin:

1. Is self-contained in its own directory
2. Has a `plugin.json` metadata file in `.claude-plugin/`
3. Implements one or more capability types (hooks, skills, commands, agents)
4. Includes a `README.md` with installation and usage documentation

## Developing Plugins

### Adding a New Plugin

1. Create a directory under the repository root (e.g., `new-plugin/`)
2. Create required structure:
   ```
   new-plugin/
   ├── .claude-plugin/plugin.json      # Required: metadata
   ├── hooks/hooks.json                # Optional: hook definitions
   ├── hooks-handlers/                 # Optional: bash scripts for hooks
   ├── skills/<skill-name>/SKILL.md    # Optional: skill definitions
   ├── commands/<command-name>.md      # Optional: slash commands
   ├── agents/<agent-name>.md          # Optional: agent definitions
   └── README.md                       # Required: documentation
   ```
3. Add plugin entry to `/.claude-plugin/marketplace.json`
4. Update root `README.md` with plugin description

### Plugin Metadata (`plugin.json`)

Required fields:
```json
{
  "name": "plugin-name",
  "description": "Brief description of plugin capabilities",
  "version": "semver",
  "author": {
    "name": "Author Name"
  },
  "keywords": ["keyword1", "keyword2"],
  "license": "MIT",
  "repository": "https://github.com/lhohan/claude-code-plugins"
}
```

### Hook Script Guidelines

Hook handler scripts (in `hooks-handlers/`) should:

- Output JSON: `{ "hookSpecificOutput": { "hookEventName": "...", "additionalContext": "..." } }`
- Include detection logic when appropriate (check for `.jj/`, `.git/`, etc.)
- Exit with code 0 on success (silent on non-applicable contexts)
- Use bash for compatibility

**Example `hooks.json`**:
```json
{
  "hooks": [
    {
      "hookEvent": "SessionStart",
      "handler": {
        "command": "bash hooks-handlers/script.sh"
      }
    }
  ]
}
```

### Skill Guidelines

Skills are markdown files with frontmatter in `skills/<skill-name>/SKILL.md`:

```markdown
---
name: skill-name
description: Brief description of what this skill does
---

Detailed instructions for Claude Code when this skill is invoked...
```

**Invocation**: `/skill skill-name` or LLM automatically invokes based on context.

### Command Guidelines

Commands are markdown files in `commands/<command-name>.md`:

```markdown
---
description: Brief description shown in command list
---

{{prompt}}

Additional context or instructions...
```

**Invocation**: `/plugin-name:command-name <arguments>`

**Variables**: Use `{{prompt}}` or `{{arg_name}}` for user-provided arguments.

### Marketplace Registration

Add entry to `.claude-plugin/marketplace.json`:

```json
{
  "name": "plugin-name",
  "source": "./plugin-directory",
  "description": "Brief description",
  "version": "semver",
  "keywords": ["keyword1", "keyword2"],
  "category": "category-name"
}
```

## Common Development Patterns

### Testing Plugins Locally

1. Add local marketplace: `/plugin marketplace add /path/to/claude-code-plugins`
2. Install from local: `/plugin install plugin-name@hanlho-plugins`
3. Restart Claude Code to load the plugin
4. Verify functionality:
   - **Hooks**: Start new session, check for context injection
   - **Skills**: Use `/skill plugin-name:skill-name`
   - **Commands**: Use `/plugin-name:command-name`

### Documentation

- Each plugin has its own `README.md` explaining features, installation, and usage
- Architectural decisions go in `docs/decisions/` with ADR format (see `jujutsu-vcs/`)
- Root `README.md` provides overview of all plugins in the marketplace

### Multi-Capability Plugins

Plugins can combine multiple capability types. For example:

```
advanced-plugin/
├── .claude-plugin/plugin.json
├── hooks/hooks.json              # SessionStart hook
├── hooks-handlers/setup.sh
├── skills/                       # Multiple skills
│   ├── skill-one/SKILL.md
│   └── skill-two/SKILL.md
├── commands/                     # Multiple commands
│   ├── cmd-one.md
│   └── cmd-two.md
├── agents/                       # Multiple agents
│   └── expert.md
└── README.md
```

**Recommendation**: Start with single capability type, expand as needed. Consolidate related capabilities (see `hanlho-cmds` pattern).

## Architectural Decisions

### Hooks vs Skills for Critical Operations

**Decision**: Use hooks for critical, must-not-forget operations (VCS integration, security reminders).

**Rationale**: LLMs lack persistent memory. Hooks guarantee context injection at session start, while skills rely on LLM memory to invoke mid-task. See `jujutsu-vcs/docs/decisions/01-use-hooks-over-skills-for-jujutsu-vcs.md`.

### Single Plugin vs Multiple Plugins

**Decision**: Consolidate related capabilities in one plugin (category-based).

**Rationale**: Better user experience (one install), simpler distribution, cohesive toolkits. Split only when capabilities serve different user personas or have independent lifecycles.

## Commit Message Style

Keep commit messages concise and focus on **what** was done, not **how**:

- ✓ `feat: add hanlho-cmds plugin with /bbh command`
- ✓ `fix: manifest error`
- ✗ `Fixed the manifest by updating the JSON structure and removing duplicate keys`

Use conventional commit prefixes: `feat:`, `fix:`, `docs:`, `refactor:`, etc.

## Repository Information

- **Marketplace name**: `hanlho-plugins`
- **Repository**: https://github.com/lhohan/claude-code-plugins
- **Owner**: Hans L'Hoest (hanlho)
- **Focus**: Architecture, code quality, development workflow automation
