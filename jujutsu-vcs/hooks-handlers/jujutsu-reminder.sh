#!/bin/bash

# Check if we're in a Jujutsu repository
if [ ! -d ".jj" ]; then
  exit 0
fi

cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "**CRITICAL: This repository uses Jujutsu (jj), not git.** Always use `jj` commands for version control operations.\n\n- Use `jj st --no-pager` to check status\n- Use `jj log --no-pager` to view history\n- Use `jj commit -m \"message\"` to create commits\n- Use `jj split -m \"message\" file1 file2` to commit only specific files\n- Use `jj bookmark set main -r @- && jj git push` to push to remote repository\nState the version control system you will be using for this session."
  }
}
EOF
exit 0
