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

#### `/hanlho-cmds:build <task-file-or-description>`

Structured multi-phase workflow for complex tasks with mandatory analysis, design approval, implementation tracking, and reflection.

**Usage:**

For file-based tasks:
```
/hanlho-cmds:build backlog/feature-implementation.md
```

For inline task descriptions:
```
/hanlho-cmds:build Implement user authentication with JWT tokens
```

This expands to a comprehensive workflow including:
- **Phase 1: Task Analysis** - Understand and confirm requirements before proceeding
- **Phase 2: Solution Design** - Propose approach and get approval before implementation
- **Phase 3: Implementation** - Execute with progress tracking and testing
- **Phase 4: Review** - Critical self-review for quality and maintainability
- **Phase 5: Submit** - Create commits following project conventions
- **Phase 6: Iterate** - Optional refinement cycles
- **Phase 7: Reflect** - Capture learnings and propose improvements
- **Phase 8: Clean Up** - Archive work and push changes

**When to use this:**
- Complex multi-step tasks requiring careful planning
- Features that need design discussion before implementation
- Tasks where you want enforced approval gates before coding
- Work that benefits from structured reflection and learning capture
- Large refactorings or architectural changes

**When NOT to use this:**
- Simple bug fixes with obvious solutions
- Tasks that can be completed in under 15 minutes
- Quick exploratory work or prototyping
- When you just want immediate feedback on code

**Why use this?**
- Prevents premature implementation through mandatory analysis phase
- Creates audit trail via notes files for session continuity
- Enforces testing, documentation, and reflection
- Captures learnings to improve future workflows
- Structured phases ensure nothing is missed (analysis, design, review, reflection)

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
