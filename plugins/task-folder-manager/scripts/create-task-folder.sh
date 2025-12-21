#!/usr/bin/env bash
# Create task folder with timestamp and device name
# Usage: create-task-folder.sh <slug>

set -euo pipefail

SLUG="${1:-unnamed-task}"
PROJECTS_PATH="/Users/ariff/Library/CloudStorage/OneDrive-Independent/dev-terminal/projects"
DATE_PART=$(date +%Y%m%d)
TIME_PART=$(date +%H%M%S)
DEVICE=$(hostname -s | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr "'" '-')
FOLDER_NAME="T${DATE_PART}.${TIME_PART}-${DEVICE}-${SLUG}"
FULL_PATH="${PROJECTS_PATH}/${FOLDER_NAME}"

# Create folder structure
mkdir -p "${FULL_PATH}"/{notes,artifacts}

# Create README
cat > "${FULL_PATH}/README.md" << EOF
# Task: ${SLUG}

**Created:** $(date '+%Y-%m-%d %H:%M:%S')
**Device:** ${DEVICE}
**Status:** 🟡 In Progress

## Objective
[What needs to be accomplished]

## Context
[Background and relevant info]

## Progress
- [ ] Step 1
- [ ] Step 2

## Outcome
[Final result - fill when complete]

## Related
- Previous:
- Docs:
EOF

echo "✅ Created task folder:"
echo "   ${FULL_PATH}"
echo ""
echo "📁 Structure:"
echo "   ${FOLDER_NAME}/"
echo "   ├── README.md"
echo "   ├── notes/"
echo "   └── artifacts/"
