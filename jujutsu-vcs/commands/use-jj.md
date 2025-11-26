---
description: Inject Jujutsu VCS context and instructions
---

**CRITICAL: This repository uses Jujutsu (jj), not git.** Always use `jj` commands for version control operations.
- Check status: `jj st --no-pager`
- View history: `jj log --no-pager`
- Create commit: `jj commit -m "message"`
- Only commit related changes: `jj commit -m "message"` [FILESETS]
  - NEVER restore files to exclude them from a commit.
- Push: `jj git push`
- Push main: `jj bookmark set main -r @- && jj git push`
- Undo last jj command: `jj undo`
- Help: `jj help`

State the version control system you will be using for this session.
