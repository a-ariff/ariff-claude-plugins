# Create New Task Folder

Creates a new task folder with auto-generated timestamp and device name.

**Pattern:** `T{YYYYMMDD}.{HHMMSS}-{device}-{slug}`

**Location:** `/Users/ariff/Library/CloudStorage/OneDrive-Independent/dev-terminal/projects/`

## Usage

```
/new-task <slug>
```

**Example:**
```
/new-task intune-policy-audit
```

Creates: `projects/T20241216.143052-ariff-macbook-intune-policy-audit/`

## Folder Contents

Each new task folder is initialized with:

```
T{timestamp}-{device}-{slug}/
├── README.md          # Task overview and status
├── notes/             # Working notes
└── artifacts/         # Output files, exports, screenshots
```

## README Template

```markdown
# Task: {slug}

**Created:** {YYYY-MM-DD HH:MM:SS}
**Device:** {hostname}
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
- Previous: [link]
- Docs: [link]
```

## Implementation

To create the folder, use the shell script:
```bash
${CLAUDE_PLUGIN_ROOT}/scripts/create-task-folder.sh <slug>
```

Or manually with Claude:
```bash
SLUG="my-task"
FOLDER="T$(date +%Y%m%d).$(date +%H%M%S)-$(hostname -s | tr '[:upper:]' '[:lower:]' | tr ' ' '-')-${SLUG}"
mkdir -p "/Users/ariff/Library/CloudStorage/OneDrive-Independent/dev-terminal/projects/${FOLDER}"/{notes,artifacts}
```
