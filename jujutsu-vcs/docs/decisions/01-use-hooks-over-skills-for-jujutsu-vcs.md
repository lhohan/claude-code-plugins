# 1. Use Hooks Over Skills for Jujutsu VCS Integration

Date: 2025-11-20

## Status

Accepted

## Context

Claude Code needs to reliably integrate Jujutsu (jj) VCS commands into workflows, ensuring that Claude always uses `jj` instead of `git` when working in Jujutsu repositories.

Two primary architectural approaches were considered:

1. **Skills-based approach**: Create a skill (SKILL.md) with Jujutsu command patterns and best practices that Claude can invoke
2. **Hooks-based approach**: Use SessionStart hooks to automatically inject context at the beginning of every session

### The LLM Forgetfulness Problem

Large language models have no persistent memory—they only see the current context window. This creates a critical reliability problem:

- **Skills are invoked mid-conversation**: Claude must recognize a task involves VCS operations and decide to invoke the skill. By the time Claude starts writing commands, it may have forgotten the context, or never recognized the situation as VCS-related.
- **Hooks are always present at start**: Context injected via SessionStart hooks is guaranteed to be visible in every session from the beginning, before any task analysis occurs.

### Precedent from Official Plugins

The official Claude Code plugins follow a clear pattern:

- **`explanatory-output-style`**: Uses SessionStart hooks to inject output format instructions
- **`security-guidance`**: Uses SessionStart hooks to inject security reminders
- **`learning-output-style`**: Uses SessionStart hooks for educational output guidance

These plugins don't use skills for persistent context injection—they use hooks. This pattern is proven and battle-tested.

## Decision

We will use a **hooks-based architecture** with a SessionStart hook for Jujutsu VCS integration.

### Implementation Details

- **Event**: SessionStart (triggers at the beginning of every session)
- **Type**: Command hook (executes a bash script)
- **Output**: JSON with `hookSpecificOutput.additionalContext` (injects context into conversation)
- **Smart Activation**: Hook only injects context when inside an actual Jujutsu repository (checks for `.jj/` directory)

## Consequences

### Positive Consequences

1. **Guaranteed Execution**: Runs automatically at session start, no decision required
2. **Always Present**: Context is injected before task analysis, preventing forgetfulness
3. **Deterministic Behavior**: Not dependent on Claude's task interpretation
4. **Proven Pattern**: Follows official Claude Code plugin architecture
5. **Efficient**: Single execution per session, minimal overhead
6. **Repository-Aware**: Only activates in actual Jujutsu repos via `.jj/` detection
7. **Easy to Test**: Hook script can be independently validated

### Negative Consequences

1. **Limited Flexibility**: Changes require script modification, not just markdown editing
2. **Token Cost**: Adds context to every session in Jujutsu repositories
3. **Execution Risk**: Script failures could impact session initialization (mitigated by silent failures on non-JJ repos)

### Mitigation Strategies

- Repository detection prevents unnecessary token usage in non-JJ projects
- Hook script logs errors for debugging
- Clear error messages if hook fails
- Extensive test coverage for hook logic

## Alternatives Considered

### Alternative 1: Pure Skills Approach

Create a Jujutsu best-practices skill that Claude invokes as needed.

**Pros:**
- Easy to modify (just edit markdown)
- Flexible LLM-driven decision making
- No scripting required

**Cons:**
- **Unreliable**: LLM must recognize VCS tasks and invoke skill mid-conversation
- **Forgetful**: By task execution time, LLM may have forgotten to check skills
- **Token overhead**: Every VCS operation triggers skill invocation
- **No guarantee**: Entirely dependent on model's judgment at specific moments
- **Pattern mismatch**: Official plugins don't use this for persistent context

**Example failure scenario:**
```
User: "Commit these changes"
Claude: *writes git commands directly without invoking the Jujutsu skill*
User: "That won't work, use jj"
Claude: *realizes mistake, invokes skill, corrects commands*
```

The hook approach prevents this failure mode entirely.

### Alternative 2: Hybrid Approach (Skills + Hooks)

Combine both hooks for reliability and skills for additional reference.

**Pros:**
- Hooks ensure reliability
- Skills provide additional flexibility
- Multiple reinforcement layers

**Cons:**
- Unnecessary complexity
- Token overhead from both mechanisms
- Harder to maintain consistency
- Unclear separation of concerns

**Why rejected**: Pure hooks achieve the reliability goal without added complexity.

### Alternative 3: CLAUDE.md Only

Rely on project-level CLAUDE.md configuration to remind Claude about Jujutsu.

**Pros:**
- No new mechanism needed
- Familiar to users

**Cons:**
- Not guaranteed to work across all projects
- Users might not add CLAUDE.md to their JJ projects
- Can't be distributed as a reusable plugin

**Why rejected**: Plugin-level hooks ensure consistency regardless of project setup.

## References

- [Claude Code Official Plugins](https://github.com/anthropics/claude-code) - Shows SessionStart hook pattern
- [explanatory-output-style Plugin](https://github.com/anthropics/claude-code) - Reference implementation
- [Jujutsu Documentation](https://github.com/martinvonz/jj) - VCS reference
- [Claude Code Hooks Documentation](https://github.com/anthropics/claude-code) - Hook specification

## Rationale Summary

**Why hooks over skills?**

LLMs work with context, not memory. When reliability matters (critical operations like VCS), the context must be present from the session start, not discovered mid-task. Hooks provide this guarantee. Skills work better for optional, decision-based capabilities, not for persistent constraints.

**Why this beats alternatives?**

1. Hooks are **guaranteed** (alternative 1 is unreliable)
2. Hooks are **simple** (alternative 2 adds unnecessary complexity)
3. Hooks are **proven** (official plugins use this pattern)
4. Hooks are **distributed** (works everywhere, not just project-specific)

This architecture provides maximum reliability for a critical system integration.
