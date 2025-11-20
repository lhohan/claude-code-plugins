#!/bin/bash

# Check if we're in a Jujutsu repository
if [ ! -d ".jj" ]; then
  exit 0
fi

# Initialize context variables
STATUS_OUTPUT=""
ALIASES_OUTPUT=""
CHEATSHEET="**CRITICAL: This repository uses Jujutsu (jj), not git.** Always use \`jj\` commands for version control operations.
- Check status: \`jj st --no-pager\`
- View history: \`jj log --no-pager\`
- Create commit: \`jj commit -m \"message\"\`
- Push: \`jj git push\`
- Push main: \`jj bookmark set main -r @- && jj git push\`
- Undo last jj command: \`jj undo\`
- Help: \`jj help\`

State the version control system you will be using for this session."

# Check for jj command
if command -v jj >/dev/null 2>&1; then
  # Get status (limit to last 20 lines to prevent massive context)
  if STATUS_CMD=$(jj status --no-pager --color=never 2>&1); then
    STATUS_OUTPUT="$STATUS_CMD"
  else
    STATUS_OUTPUT="Error retrieving status: $STATUS_CMD"
  fi

  # Get aliases
  ALIASES_OUTPUT=$(jj config list --no-pager --color=never 2>/dev/null | grep '^aliases\.' | sed 's/^aliases\.//' | sort | head -n 20)
  if [ -z "$ALIASES_OUTPUT" ]; then
      ALIASES_OUTPUT="(No custom aliases configured)"
  fi
else
  STATUS_OUTPUT="Error: 'jj' command not found in PATH. Please install Jujutsu."
  ALIASES_OUTPUT="Cannot retrieve aliases (jj not found)."
fi

# Construct the raw context message
CONTEXT="**Jujutsu (jj) Repository Detected**

## Current Status
\`\`\`
$STATUS_OUTPUT
\`\`\`

## Configured Aliases
\`\`\`
$ALIASES_OUTPUT
\`\`\`

## Cheat Sheet
$CHEATSHEET
"

# JSON Escaping
# 1. Escape backslashes (\ -> \\)
# 2. Escape double quotes (" -> \")
# 3. Escape newlines (actual newline -> \n literal)
# 4. Escape tabs (tab -> \t literal)
# tr -d '\n' removes the actual newlines after sed converts them to \n strings
ESCAPED_CONTEXT=$(echo "$CONTEXT" | sed 's/\\/\\\\/g; s/"/\\"/g; s/$/\\n/g; s/	/\\t/g' | tr -d '\n')

# Construct JSON
echo "{
  \"hookSpecificOutput\": {
    \"hookEventName\": \"SessionStart\",
    \"additionalContext\": \"$ESCAPED_CONTEXT\"
  }
}"
exit 0
