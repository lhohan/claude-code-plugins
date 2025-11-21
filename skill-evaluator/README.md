# Skill Evaluator Plugin

A Claude Code plugin that provides comprehensive evaluation of Claude Code skills against best practices, including size, structure, examples, and prompt engineering quality.

## Features

- **Dimensional Analysis**: Evaluates skills across 8 key dimensions:
  - Size & Length compliance
  - Scope Definition clarity
  - Description Quality
  - Structure & Organization
  - Examples adequacy
  - Anti-Pattern Detection
  - Prompt Engineering Quality
  - Completeness

- **Comprehensive Reports**: Generates detailed evaluation reports with:
  - Executive summary
  - Metrics and compliance assessment
  - Issue severity classification (Critical/Warning/Observation)
  - Comparative analysis against official best practices
  - Actionable improvement suggestions prioritized by impact

- **Best Practices Alignment**: Evaluates against:
  - Official Anthropic Claude Code Skills documentation
  - Official skills repository patterns
  - Professional technical writing standards
  - LLM prompt engineering best practices

## Installation

Add the marketplace and install the plugin:

```bash
/plugin marketplace add lhohan/claude-code-plugins
/plugin install skill-evaluator@claude-code-plugins
```

## Usage

Invoke the skill when you need to evaluate a Claude Code skill:

```
Please evaluate the skill-evaluator skill against best practices
```

The evaluator will:
1. Identify and read the target skill's `SKILL.md` file
2. Analyze it across 8 dimensions of quality
3. Generate a comprehensive evaluation report
4. Provide specific, actionable improvement suggestions

## What Gets Evaluated

### Size & Length
- SKILL.md body under 500 lines (hard maximum)
- Name limited to 64 characters
- Description limited to 1024 characters (200 char summary preferred)
- Table of Contents for files over 100 lines

### Scope Definition
- Narrow focus (one skill = one capability)
- Clear boundaries of what the skill does and doesn't do
- No scope creep or conflicting capabilities

### Description Quality
- Third-person voice (not "I can" or "you can")
- Includes both WHAT and WHEN TO USE
- Specific, searchable terminology

### Structure & Organization
- Clear section hierarchy
- Logical flow with progressive disclosure
- Step-by-step instructions for workflows
- Clear rules and constraints

### Examples
- Quality over quantity (typically 2-3 examples)
- Concrete and realistic demonstrations
- Show patterns and edge cases

### Anti-Patterns
- Windows-style paths (should use forward slashes)
- Magic numbers without justification
- Vague terminology
- Time-sensitive instructions
- Deeply nested file references
- Lack of error handling
- No user feedback loops
- Multiple conflicting approaches

### Prompt Engineering Quality
- Imperative language
- Explicit rules with clear boundaries
- Validation loops for critical operations
- Clear error handling

### Completeness
- Requirements clearly listed
- Edge cases acknowledged
- Limitations stated

## References

- [Official EXAMPLE Report](./references/EXAMPLE.md) - Sample evaluation report showing format and analysis depth

## About

Part of the [Hanlho's Claude Code Plugins](https://github.com/lhohan/claude-code-plugins) collection.

**Version**: 0.1.0
**License**: MIT
**Author**: Hans L'Hoest
