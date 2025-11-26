#!/bin/bash
set -e

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEMP_DIR="/tmp/hanlho-plugins-local-$$"

echo "🔧 Creating local marketplace copy in temp directory..."

# 1. Create temp directory structure
mkdir -p "$TEMP_DIR/.claude-plugin"

# 2. Copy entire repository structure to temp
cp -r "$REPO_ROOT"/* "$TEMP_DIR/" 2>/dev/null || true
cp -r "$REPO_ROOT"/.claude-plugin "$TEMP_DIR/"

echo "✓ Copied repository to: $TEMP_DIR"

# 3. Modify marketplace.json in TEMP (not in repo!)
TEMP_MARKETPLACE="$TEMP_DIR/.claude-plugin/marketplace.json"
jq '.name = "hanlho-plugins-local" |
    .plugins = [.plugins[] | .name = (.name + "-local")]' \
  "$TEMP_MARKETPLACE" > "$TEMP_MARKETPLACE.tmp"
mv "$TEMP_MARKETPLACE.tmp" "$TEMP_MARKETPLACE"

echo "✓ Renamed marketplace to 'hanlho-plugins-local' (in temp)"

# 4. Modify each plugin.json in TEMP (not in repo!)
for plugin_dir in "$TEMP_DIR"/*/; do
  plugin_json="$plugin_dir/.claude-plugin/plugin.json"
  if [ -f "$plugin_json" ]; then
    plugin_name=$(basename "$plugin_dir")
    jq '.name = (.name + "-local")' "$plugin_json" > "$plugin_json.tmp"
    mv "$plugin_json.tmp" "$plugin_json"
    echo "  ✓ Renamed: $plugin_name → $plugin_name-local (in temp)"
  fi
done

# 5. Add temp marketplace to Claude Code
echo "📦 Adding temporary marketplace to Claude Code..."
if claude plugin marketplace add "$TEMP_DIR" 2>/dev/null; then
  echo "✓ Marketplace added"
else
  echo "ℹ️  Marketplace already exists (will update plugins)"
fi

# 6. Install plugins from temp location
echo "📥 Installing plugins from temporary marketplace..."
claude plugin install jujutsu-vcs-local@hanlho-plugins-local
claude plugin install skill-evaluator-local@hanlho-plugins-local
claude plugin install hanlho-cmds-local@hanlho-plugins-local

echo "✓ Plugins installed from temp location"

echo ""
echo "✅ Local marketplace installed successfully!"
echo ""
echo "⚠️  IMPORTANT: Restart Claude Code for plugins to load"
echo ""
echo "Command Usage:"
echo "  - Local: /hanlho-cmds-local:bbh"
echo "  - Remote: /hanlho-cmds:bbh"
echo ""
echo "Your working repository is UNTOUCHED - ready to commit anytime!"
echo ""
echo "To reinstall after changes: ./scripts/install-local-marketplace.sh"
echo "Temp files at: $TEMP_DIR"
