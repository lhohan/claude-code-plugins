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

#### `/hanlho-cmds:bsky-thread <text-or-file-path>`

Split text into Bluesky thread messages (300 characters per post) with intelligent breaks and optional improvements.

**Usage:**

Direct text input:
```
/hanlho-cmds:bsky-thread I have a long article I want to post on Bluesky but it doesn't fit in a single post...
```

File input:
```
/hanlho-cmds:bsky-thread ./my-article.txt
```

The command will:
- Split the text at natural boundaries (paragraphs, sentences)
- Show how many messages you'll need (e.g., "This will create 5 messages")
- Display each message with thread numbering `[1/5]`, `[2/5]`, etc.
- Include character count for each message
- Suggest alternative split points for better narrative flow
- Propose minor clarity edits (without changing tone or content)

**Why use this?**
- Bluesky's 300 character limit makes threading necessary for long content
- Intelligent splitting maintains narrative flow
- Suggestions help optimize message pacing and readability

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
