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

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
PLUGINS_SOURCE="$REPO_ROOT/plugins"
CLAUDE_DIR="$HOME/.claude"
MARKETPLACE="$REPO_ROOT/.claude-plugin/marketplace.json"

print_header() {
    echo -e "${BLUE}"
    echo "============================================================"
    echo "  Claude Code Plugin Installer"
    echo "  53 plugins: 22 agents, 26 skills, 3 hooks, 2 commands"
    echo "============================================================"
    echo -e "${NC}"
}

print_success() { echo -e "${GREEN}  ok${NC}  $1"; }
print_warning() { echo -e "${YELLOW}  !!${NC}  $1"; }
print_error()   { echo -e "${RED}  xx${NC}  $1"; }
print_info()    { echo -e "${BLUE}  --${NC}  $1"; }

# Detect what type a plugin is by looking at its directories
detect_category() {
    local plugin_dir="$1"
    if [ -d "$plugin_dir/agents" ]; then
        echo "agents"
    elif [ -f "$plugin_dir/hooks/hooks.json" ]; then
        echo "hooks"
    elif [ -d "$plugin_dir/commands" ]; then
        echo "commands"
    elif [ -d "$plugin_dir/skills" ]; then
        echo "skills"
    else
        echo "plugins"
    fi
}

list_plugins() {
    echo ""
    echo "Available Plugins (53):"
    echo ""

    for category in agents skills hooks commands; do
        echo "  ${category}:"
        for plugin_dir in "$PLUGINS_SOURCE"/*/; do
            if [ -d "$plugin_dir" ]; then
                local detected=$(detect_category "$plugin_dir")
                if [ "$detected" = "$category" ]; then
                    local name=$(basename "$plugin_dir")
                    local desc=""
                    local manifest="$plugin_dir/.claude-plugin/plugin.json"
                    if [ -f "$manifest" ]; then
                        desc=$(python3 -c "import json; print(json.load(open('$manifest')).get('description',''))" 2>/dev/null || echo "")
                    fi
                    if [ -n "$desc" ]; then
                        echo "    $name -- $desc"
                    else
                        echo "    $name"
                    fi
                fi
            fi
        done
        echo ""
    done
}

install_plugin() {
    local plugin_name="$1"
    local source_dir="$PLUGINS_SOURCE/$plugin_name"

    if [ ! -d "$source_dir" ]; then
        print_error "Plugin not found: $plugin_name"
        return 1
    fi

    local category=$(detect_category "$source_dir")

    # Copy agent markdown files
    if [ -d "$source_dir/agents" ]; then
        mkdir -p "$CLAUDE_DIR/agents"
        cp "$source_dir"/agents/*.md "$CLAUDE_DIR/agents/" 2>/dev/null || true
    fi

    # Copy skill directories
    if [ -d "$source_dir/skills" ]; then
        mkdir -p "$CLAUDE_DIR/skills"
        for skill_dir in "$source_dir"/skills/*/; do
            if [ -d "$skill_dir" ]; then
                local skill_name=$(basename "$skill_dir")
                mkdir -p "$CLAUDE_DIR/skills/$skill_name"
                cp "$skill_dir"/* "$CLAUDE_DIR/skills/$skill_name/" 2>/dev/null || true
            fi
        done
        # Also copy flat skill files (skill.md pattern)
        for skill_file in "$source_dir"/skills/*.md; do
            if [ -f "$skill_file" ]; then
                local skill_base=$(basename "$skill_file" .md)
                skill_base=$(basename "$skill_base" .skill)
                mkdir -p "$CLAUDE_DIR/skills/$skill_base"
                cp "$skill_file" "$CLAUDE_DIR/skills/$skill_base/SKILL.md" 2>/dev/null || true
            fi
        done
    fi

    # Copy hooks
    if [ -f "$source_dir/hooks/hooks.json" ]; then
        mkdir -p "$CLAUDE_DIR/hooks"
        cp "$source_dir/hooks/hooks.json" "$CLAUDE_DIR/hooks/${plugin_name}-hooks.json" 2>/dev/null || true
    fi

    # Copy commands
    if [ -d "$source_dir/commands" ]; then
        mkdir -p "$CLAUDE_DIR/commands"
        cp "$source_dir"/commands/*.md "$CLAUDE_DIR/commands/" 2>/dev/null || true
    fi

    # Copy scripts (needed by hooks)
    if [ -d "$source_dir/scripts" ]; then
        mkdir -p "$CLAUDE_DIR/scripts"
        cp "$source_dir"/scripts/* "$CLAUDE_DIR/scripts/" 2>/dev/null || true
        chmod +x "$CLAUDE_DIR/scripts/"* 2>/dev/null || true
    fi

    print_success "$plugin_name ($category)"
}

install_all() {
    print_info "Installing all plugins to ~/.claude/ ..."
    echo ""

    mkdir -p "$CLAUDE_DIR"/{agents,skills,hooks,commands,scripts}

    local count=0
    local failed=0

    for plugin_dir in "$PLUGINS_SOURCE"/*/; do
        if [ -d "$plugin_dir" ]; then
            local plugin_name=$(basename "$plugin_dir")
            if install_plugin "$plugin_name"; then
                ((count++))
            else
                ((failed++))
            fi
        fi
    done

    echo ""
    echo "============================================================"
    print_success "Installed $count plugins to ~/.claude/"
    [ $failed -gt 0 ] && print_warning "Failed: $failed plugins"
    echo ""
    echo "  Next steps:"
    echo "    1. Start a new Claude Code session: claude"
    echo "    2. Type /browse to see all available plugins"
    echo "    3. Try: 'run a security review on my code'"
    echo ""
}

uninstall_all() {
    print_warning "This will remove all installed plugins from ~/.claude/"
    echo ""
    read -p "  Continue? (y/N) " confirm

    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        rm -rf "$CLAUDE_DIR/agents"
        rm -rf "$CLAUDE_DIR/skills"
        rm -rf "$CLAUDE_DIR/hooks"
        rm -rf "$CLAUDE_DIR/commands"
        rm -rf "$CLAUDE_DIR/scripts"
        print_success "All plugins removed from ~/.claude/"
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
            echo "  Usage: $0 --plugin PLUGIN_NAME"
            echo "  Example: $0 --plugin security-analyst"
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
        echo "  (no options)              Install all 53 plugins"
        echo "  --list, -l                List available plugins"
        echo "  --plugin, -p NAME         Install a single plugin"
        echo "  --uninstall, -u           Remove all installed plugins"
        echo "  --help, -h                Show this help"
        echo ""
        echo "Examples:"
        echo "  bash install.sh                          # install everything"
        echo "  bash install.sh --plugin architect       # install one plugin"
        echo "  bash install.sh --list                   # see what's available"
        ;;
    *)
        install_all
        ;;
esac
