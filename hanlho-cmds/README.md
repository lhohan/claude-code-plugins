# Hanlho Commands Plugin

Curated most useful & frequently used Claude Code commands for Claude development and workflow automation.

## Features

### Commands

#### `/hanlho-cmds:bbh <prompt>`

Request brutally honest feedback by automatically appending "Be brutally honest." to your prompt.

**Usage:**
```
/hanlho-cmds:bbh What do you think about my code architecture?
```

This expands to:
```
What do you think about my code architecture?

Be brutally honest.
```

**Why use this?**
- Ensures you get direct, unfiltered technical feedback
- Saves typing the same instruction repeatedly
- Encourages objective analysis over false validation

## Installation

### From Local Marketplace

If you have this repository cloned locally:

```bash
/plugin marketplace add /path/to/claude-code-plugins
/plugin install hanlho-cmds@hanlho-plugins
```

### From GitHub (once published)

```bash
/plugin marketplace add https://github.com/lhohan/claude-code-plugins
/plugin install hanlho-cmds@hanlho-plugins
```

## About

Part of the [Hanlho's Claude Code Plugins](https://github.com/lhohan/claude-code-plugins) collection.

## License

MIT
