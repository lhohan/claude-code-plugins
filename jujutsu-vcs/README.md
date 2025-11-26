# Jujutsu VCS Plugin for Claude Code

This plugin provides the most reliable way I have found to instruct Claude Code to use Jujutsu (`jj`) commands instead of git when working in Jujutsu repositories. 

## Features

- **SessionStart Hook**: Automatically reminds Claude to use `jj` commands at session start
- **Manual Command**: `/use-jj` command for on-demand context injection (fallback if hooks fail)
- **Repository-Aware**: Only activates in actual Jujutsu repositories (checks for `.jj/` directory)
- **Reliable**: Uses context injection instead of skill invocation for guaranteed execution
- **Reference Guide**: Includes common `jj` commands for quick reference

## Is it working?

To test if the plugin is working, ask the LLM:

```bash
State the version control system you will be using for this session.
```

## Installation

### Using Claude Code Plugin Manager (Recommended)

1. Add the marketplace:
   ```bash
   /plugin marketplace add lhohan/claude-code-plugins
   ```

2. Install the plugin:
   ```bash
   /plugin install jujutsu-vcs@claude-code-plugins
   ```

### Manual Installation (Local Development)

1. Clone the repository:
   ```bash
   git clone https://github.com/lhohan/claude-code-plugins.git
   cd claude-code-plugins
   ```

2. Add the local marketplace:
   ```bash
   /plugin marketplace add ./
   ```

3. Install the plugin:
   ```bash
   /plugin install jujutsu-vcs@claude-code-plugins
   ```

## Usage

### Automatic Context Injection (SessionStart Hook)

Once installed, the plugin automatically activates when you enter a Jujutsu repository:

```bash
cd /path/to/jujutsu-repo
claude
```

Claude will receive a reminder to use `jj` commands in all subsequent operations.

### Manual Context Injection (Command)

If the SessionStart hook doesn't trigger for some reason, you can manually inject the same context by running:

```
/use-jj
```

This provides an alternative way to get the Jujutsu context reminder within the same session.

## Optional: add extra layer

For maximum reliability with LLMs that "forget things," you could at an extra layer in addition to using this plugin, add to your project's CLAUDE.md:

```markdown
  ## Version Control
  **CRITICAL: This repository uses Jujutsu (jj), not git.**
  Always use jj commands for version control operations.
```

## What It Does

The plugin injects a context similar to the one below at session start:

```
CRITICAL: This repository uses Jujutsu (jj), not git. Always use jj commands.

- jj st --no-pager       (check status)
- jj log --no-pager      (view history)
- jj commit -m "message" (create commits)
- jj split -m "message"  (commit specific files)
- jj bookmark set && jj git push (push to remote)
```

## Why Hooks Over Skills?

See [`docs/decisions/0001-use-hooks-over-skills-for-jujutsu-vcs.md`](docs/decisions/0001-use-hooks-over-skills-for-jujutsu-vcs.md) for the detailed architectural decision.

**TL;DR**: LLMs have no persistent memory. Hooks guarantee context is present from session start, while skills require the model to remember to invoke them mid-task. For critical operations like VCS, hooks are more reliable.

## Token Cost

This plugin adds approximately 150-200 tokens to each session in Jujutsu repositories. The hook only activates when `.jj/` is detected, so non-Jujutsu projects are unaffected.

## Uninstalling

```bash
/plugin uninstall jujutsu-vcs
```
