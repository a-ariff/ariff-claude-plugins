#!/bin/bash
# =============================================================================
# Setup Repository Link
# =============================================================================
# Creates a reference link between the private config and public marketplace
# so your private config can pull updates from the marketplace.
#
# Usage: bash setup-repo-link.sh
# =============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MARKETPLACE_ROOT="$(dirname "$SCRIPT_DIR")"
CONFIG_ROOT="$(dirname "$MARKETPLACE_ROOT")/Ariff-code-config"

echo -e "${BLUE}Setting up repository link...${NC}"
echo ""

# Create .marketplace-link in config repo
LINK_FILE="$CONFIG_ROOT/.marketplace-link"

cat > "$LINK_FILE" << 'EOF'
# Marketplace Link Configuration
# This file links your private config to the public marketplace

MARKETPLACE_REPO="https://github.com/a-ariff/ariff-claude-plugins.git"
MARKETPLACE_LOCAL="../ariff-claude-plugins"
SYNC_MODE="pull"  # pull = get updates from marketplace, push = contribute back

# To update plugins from marketplace:
# cd $(dirname $0)
# bash scripts/sync-from-marketplace.sh

# To contribute a plugin to marketplace:
# 1. Develop in your private config
# 2. Test thoroughly
# 3. Copy to marketplace repo
# 4. Open PR on GitHub
EOF

echo -e "${GREEN}✓${NC} Created: $LINK_FILE"

# Create sync script in config repo
SYNC_SCRIPT="$CONFIG_ROOT/scripts/sync-from-marketplace.sh"
mkdir -p "$(dirname "$SYNC_SCRIPT")"

cat > "$SYNC_SCRIPT" << 'EOF'
#!/bin/bash
# Sync plugins from public marketplace to private config

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_ROOT="$(dirname "$SCRIPT_DIR")"
MARKETPLACE_ROOT="$(dirname "$CONFIG_ROOT")/ariff-claude-plugins"

if [ ! -d "$MARKETPLACE_ROOT" ]; then
    echo "Marketplace not found. Cloning..."
    git clone https://github.com/a-ariff/ariff-claude-plugins.git "$MARKETPLACE_ROOT"
fi

echo "Pulling latest from marketplace..."
cd "$MARKETPLACE_ROOT"
git pull origin main

echo "Syncing plugins to config..."
rsync -av --exclude='.git' --exclude='.DS_Store' \
    "$MARKETPLACE_ROOT/plugins/" "$CONFIG_ROOT/.claude-plugin/plugins/"

echo "✓ Sync complete!"
EOF

chmod +x "$SYNC_SCRIPT"
echo -e "${GREEN}✓${NC} Created: $SYNC_SCRIPT"

echo ""
echo "Repository link established!"
echo ""
echo "Your setup now supports:"
echo "  • Private config at: Ariff-code-config (personal)"
echo "  • Public marketplace at: ariff-claude-plugins (shareable)"
echo ""
echo "To sync updates from marketplace:"
echo "  cd Ariff-code-config && bash scripts/sync-from-marketplace.sh"
