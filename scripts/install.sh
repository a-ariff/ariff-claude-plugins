#!/bin/bash
# =============================================================================
# Ariff's Claude Code Plugin Installer
# =============================================================================
# Usage:
#   bash install.sh                    # Install all plugins
#   bash install.sh --plugin NAME      # Install specific plugin
#   bash install.sh --list             # List available plugins
#   bash install.sh --uninstall        # Remove all plugins
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
CLAUDE_DIR="$HOME/.claude"
PLUGINS_SOURCE="$REPO_ROOT/plugins"

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*)  echo "linux" ;;
        MINGW*|CYGWIN*|MSYS*) echo "windows" ;;
        *) echo "unknown" ;;
    esac
}

OS=$(detect_os)

print_header() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║     🔌 Ariff's Claude Code Plugin Installer                  ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Count plugins by category
count_plugins() {
    local category=$1
    if [ -f "$REPO_ROOT/marketplace.json" ]; then
        grep -c "\"category\": \"$category\"" "$REPO_ROOT/marketplace.json" 2>/dev/null || echo "0"
    else
        echo "0"
    fi
}

list_plugins() {
    echo ""
    echo "Available Plugins:"
    echo "=================="
    echo ""
    
    if [ -f "$REPO_ROOT/marketplace.json" ]; then
        # Use jq if available, otherwise fallback to grep
        if command -v jq &> /dev/null; then
            echo "Agents:"
            jq -r '.plugins[] | select(.category == "agents") | "  - \(.name): \(.description)"' "$REPO_ROOT/marketplace.json"
            echo ""
            echo "Skills:"
            jq -r '.plugins[] | select(.category == "skills") | "  - \(.name): \(.description)"' "$REPO_ROOT/marketplace.json"
            echo ""
            echo "Hooks:"
            jq -r '.plugins[] | select(.category == "hooks") | "  - \(.name): \(.description)"' "$REPO_ROOT/marketplace.json"
            echo ""
            echo "Commands:"
            jq -r '.plugins[] | select(.category == "commands") | "  - \(.name): \(.description)"' "$REPO_ROOT/marketplace.json"
        else
            ls -1 "$PLUGINS_SOURCE" 2>/dev/null | while read plugin; do
                echo "  - $plugin"
            done
        fi
    else
        ls -1 "$PLUGINS_SOURCE" 2>/dev/null | while read plugin; do
            echo "  - $plugin"
        done
    fi
    echo ""
}

install_plugin() {
    local plugin_name=$1
    local source_dir="$PLUGINS_SOURCE/$plugin_name"
    
    if [ ! -d "$source_dir" ]; then
        print_error "Plugin not found: $plugin_name"
        return 1
    fi
    
    # Read manifest to determine category
    local manifest="$source_dir/manifest.json"
    local category="plugins"
    
    if [ -f "$manifest" ] && command -v jq &> /dev/null; then
        category=$(jq -r '.category // "plugins"' "$manifest")
    fi
    
    # Determine target directory
    local target_dir="$CLAUDE_DIR/$category"
    mkdir -p "$target_dir"
    
    # Copy plugin files
    cp -r "$source_dir"/* "$target_dir/" 2>/dev/null || cp -r "$source_dir" "$target_dir/"
    
    print_success "Installed: $plugin_name → ~/.claude/$category/"
}

install_all() {
    print_info "Installing all plugins..."
    echo ""
    
    # Create directories
    mkdir -p "$CLAUDE_DIR"/{agents,skills,hooks,commands,plugins}
    
    local count=0
    local failed=0
    
    for plugin_dir in "$PLUGINS_SOURCE"/*/; do
        if [ -d "$plugin_dir" ]; then
            plugin_name=$(basename "$plugin_dir")
            if install_plugin "$plugin_name"; then
                ((count++))
            else
                ((failed++))
            fi
        fi
    done
    
    echo ""
    print_success "Installation complete!"
    echo "  Installed: $count plugins"
    [ $failed -gt 0 ] && echo "  Failed: $failed plugins"
    echo ""
    echo "Restart Claude Code to use your new plugins."
}

uninstall_all() {
    print_warning "This will remove all plugins from ~/.claude/"
    read -p "Continue? (y/N) " confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rm -rf "$CLAUDE_DIR/agents"
        rm -rf "$CLAUDE_DIR/skills"  
        rm -rf "$CLAUDE_DIR/hooks"
        rm -rf "$CLAUDE_DIR/commands"
        rm -rf "$CLAUDE_DIR/plugins"
        print_success "All plugins removed"
    else
        print_info "Cancelled"
    fi
}

# Main
print_header

case "${1:-}" in
    --list|-l)
        list_plugins
        ;;
    --plugin|-p)
        if [ -z "${2:-}" ]; then
            print_error "Please specify a plugin name"
            echo "Usage: $0 --plugin PLUGIN_NAME"
            exit 1
        fi
        install_plugin "$2"
        ;;
    --uninstall|-u)
        uninstall_all
        ;;
    --help|-h)
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --list, -l              List available plugins"
        echo "  --plugin, -p NAME       Install specific plugin"
        echo "  --uninstall, -u         Remove all plugins"
        echo "  --help, -h              Show this help"
        echo ""
        echo "Without options, installs all plugins."
        ;;
    *)
        install_all
        ;;
esac
