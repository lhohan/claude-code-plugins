# Claude Code Plugins

A collection of reusable plugins for Claude Code to enhance your development workflow.

## Plugins

### [Jujutsu VCS Plugin](./jujutsu-vcs)

### [Skill Evaluator](./skill-evaluator)

### [Hanlho Commands](./hanlho-cmds)

## Local Development

### Setup

This repository uses **Nix flakes** to provide a reproducible development environment with all required dependencies (including `jq` for the install script).

**Prerequisites:**
- [Nix](https://nixos.org/download) (flakes support)
- [direnv](https://direnv.net/)

**Initial Setup:**

```bash
# Allow direnv to load the flake
direnv allow

# You should see output like:
# 🔧 Claude Code plugins dev environment loaded
# jq version: jq-1.6
```

The environment will automatically load when you enter the directory and unload when you leave.

### Installing Local Plugins for Development

Once your development environment is active (via direnv), install the local version of plugins:

```bash
# Install local development version
./scripts/install-local-marketplace.sh

# Restart Claude Code (important!)
# Then test your plugins
```

**How it works:**
1. Copies your entire repository to a temp directory
2. Modifies the temp copies (marketplace → `hanlho-plugins-local`, plugins get `-local` suffix)
3. Installs plugins from the temp directory
4. **Your working repository is never touched** ✓

This approach is idempotent - you can run it 100 times with the same result. No restore step needed!

### Using Local vs Remote Versions

Once installed, you can use both versions simultaneously:

```bash
# Use local development commands
/hanlho-cmds-local:bbh

# Use remote published commands
/hanlho-cmds:bbh

# Install specific plugin versions
/plugin install jujutsu-vcs-local@hanlho-plugins-local   # Local
/plugin install jujutsu-vcs@hanlho-plugins               # Remote
```

### Development Workflow

1. **Make changes** to any plugin in your working directory
2. **Reinstall** local plugins to test changes:
   ```bash
   ./scripts/install-local-marketplace.sh
   ```
3. **Restart Claude Code** to reload plugins
4. **Commit and push** when ready
   ```bash
   jj commit -m "feat: your change"
   jj git push
   ```

   ✓ No special steps needed - your working files were never modified!

## License

MIT
