#!/usr/bin/env bash
# Load project context on session start
# Provides Claude with relevant project information

set -euo pipefail

CONTEXT=""

# Load project name if CLAUDE.md exists
if [ -f "$CLAUDE_PROJECT_DIR/CLAUDE.md" ]; then
  CONTEXT+="Project instructions loaded from CLAUDE.md. "
fi

# Add git information if available
if [ -d "$CLAUDE_PROJECT_DIR/.git" ]; then
  BRANCH=$(git -C "$CLAUDE_PROJECT_DIR" branch --show-current 2>/dev/null || echo "unknown")
  UNCOMMITTED=$(git -C "$CLAUDE_PROJECT_DIR" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
  CONTEXT+="Git branch: $BRANCH. Uncommitted changes: $UNCOMMITTED files. "
fi

# Add Node.js project info
if [ -f "$CLAUDE_PROJECT_DIR/package.json" ]; then
  PKG_NAME=$(jq -r '.name // "unnamed"' "$CLAUDE_PROJECT_DIR/package.json" 2>/dev/null || echo "unnamed")
  CONTEXT+="Node.js project: $PKG_NAME. "
fi

# Add Python project info
if [ -f "$CLAUDE_PROJECT_DIR/pyproject.toml" ] || [ -f "$CLAUDE_PROJECT_DIR/setup.py" ]; then
  CONTEXT+="Python project detected. "
fi

# Output structured JSON if we have context
if [ -n "$CONTEXT" ]; then
  cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "$CONTEXT"
  }
}
EOF
fi

exit 0
