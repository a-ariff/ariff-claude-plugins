#!/bin/bash
# =============================================================================
# Migration Script: Copy plugins from Ariff-code-config to ariff-claude-plugins
# =============================================================================
# This script copies all plugins from your private config repo to the 
# public marketplace repo.
#
# Usage: bash migrate-from-config.sh
# =============================================================================

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MARKETPLACE_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIG_ROOT="$(dirname "$MARKETPLACE_ROOT")/Ariff-code-config"

echo -e "${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     Plugin Migration: Config → Marketplace                   ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check source exists
if [ ! -d "$CONFIG_ROOT/.claude-plugin/plugins" ]; then
    echo -e "${YELLOW}⚠ Source not found: $CONFIG_ROOT/.claude-plugin/plugins${NC}"
    echo "Please ensure Ariff-code-config is in the same parent directory."
    exit 1
fi

SOURCE_PLUGINS="$CONFIG_ROOT/.claude-plugin/plugins"
TARGET_PLUGINS="$MARKETPLACE_ROOT/plugins"

echo "Source: $SOURCE_PLUGINS"
echo "Target: $TARGET_PLUGINS"
echo ""

# Count plugins
total=$(ls -1d "$SOURCE_PLUGINS"/*/ 2>/dev/null | wc -l | tr -d ' ')
echo "Found $total plugins to migrate"
echo ""

# Copy each plugin
count=0
for plugin_dir in "$SOURCE_PLUGINS"/*/; do
    if [ -d "$plugin_dir" ]; then
        plugin_name=$(basename "$plugin_dir")
        
        # Skip .DS_Store and hidden folders
        [[ "$plugin_name" == .* ]] && continue
        
        echo -e "${GREEN}→${NC} Copying: $plugin_name"
        
        # Create target directory
        mkdir -p "$TARGET_PLUGINS/$plugin_name"
        
        # Copy all files except .DS_Store
        rsync -a --exclude='.DS_Store' "$plugin_dir" "$TARGET_PLUGINS/$plugin_name/" 2>/dev/null || \
        cp -r "$plugin_dir"/* "$TARGET_PLUGINS/$plugin_name/" 2>/dev/null || true
        
        ((count++))
    fi
done

echo ""
echo -e "${GREEN}✓ Migration complete!${NC}"
echo "  Copied: $count plugins"
echo ""
echo "Next steps:"
echo "  1. Review plugins in: $TARGET_PLUGINS"
echo "  2. Remove any private/personal content"
echo "  3. Initialize git and push to GitHub:"
echo ""
echo "     cd $MARKETPLACE_ROOT"
echo "     git init"
echo "     git add ."
echo "     git commit -m 'initial commit: 41 claude code plugins'"
echo "     git remote add origin https://github.com/a-ariff/ariff-claude-plugins.git"
echo "     git push -u origin main"
