# Plugin Structure Guide

This document explains how Claude Code plugins are structured and how they work.

## Overview

Claude Code plugins extend Claude's capabilities through four mechanisms:

| Type | Purpose | How Claude Uses It |
|------|---------|-------------------|
| **Agents** | Autonomous specialists | Delegates tasks via `@agent-name` |
| **Skills** | Reusable capabilities | Applies techniques via skill reference |
| **Hooks** | Event automation | Triggers on specific events |
| **Commands** | Custom workflows | Executes via `/command-name` |

## Directory Structure

```
plugins/
└── your-plugin/
    ├── manifest.json         # Required: Plugin metadata
    ├── your-plugin.md        # Required: Main plugin content
    ├── README.md             # Optional: Documentation
    └── examples/             # Optional: Usage examples
        └── example-1.md
```

## Manifest Schema

### Required Fields

```json
{
  "name": "your-plugin",
  "version": "1.0.0",
  "description": "What this plugin does",
  "category": "agents|skills|hooks|commands"
}
```

### Optional Fields

```json
{
  "tags": ["tag1", "tag2"],
  "author": {
    "name": "Your Name",
    "github": "username"
  },
  "files": ["your-plugin.md"],
  "dependencies": ["other-plugin"],
  "claude_code_version": ">=1.0.0",
  "triggers": ["pattern1", "pattern2"],
  "events": ["pre-tool-call", "post-response"]
}
```

## Plugin Types

### Agents

Agents are autonomous specialists that handle specific domains.

**File Structure:**
```markdown
---
name: architect-agent
type: agent
description: System design specialist
triggers:
  - "design"
  - "architecture"
  - "system design"
---

# Architect Agent

## Role
I am a system design specialist...

## Capabilities
- Design distributed systems
- Create architecture diagrams
- Review technical decisions

## Workflow
1. Analyze requirements
2. Identify constraints
3. Propose architecture
4. Document decisions

## Tools I Use
- Mermaid for diagrams
- ADR format for decisions
```

### Skills

Skills are reusable techniques that enhance problem-solving.

**File Structure:**
```markdown
---
name: systematic-debugging
type: skill
description: Methodical bug investigation
---

# Systematic Debugging

## Purpose
A methodical approach to finding and fixing bugs.

## The Technique

### Step 1: Reproduce
- Get exact reproduction steps
- Note environment details
- Capture error messages

### Step 2: Isolate
- Binary search the codebase
- Eliminate possibilities
- Find minimal reproduction

### Step 3: Identify
- Trace execution path
- Inspect state at each step
- Find the root cause

### Step 4: Fix
- Implement minimal fix
- Add test coverage
- Verify fix works

## When to Use
- Complex bugs
- Intermittent failures
- Production issues
```

### Hooks

Hooks trigger automatically on specific events.

**File Structure:**
```markdown
---
name: assumption-checker
type: hook
trigger: pre-tool-call
events:
  - tool_call
---

# Assumption Checker Hook

## Trigger Conditions
Activates before any tool call.

## Actions
1. Check if assumptions are documented
2. Verify prerequisites are met
3. Warn if Canvas API is involved

## Configuration
```json
{
  "strict_mode": true,
  "canvas_warnings": true
}
```

## Example Output
⚠️ WARNING: This action assumes the Canvas API is configured.
Please verify before proceeding.
```

### Commands

Commands are custom slash commands for workflows.

**File Structure:**
```markdown
---
name: deep-search
type: command
trigger: /deep-search
---

# Deep Search Command

## Usage
```
/deep-search <query> [--sources github,reddit,docs]
```

## What It Does
1. Searches GitHub for relevant code
2. Searches Reddit for discussions
3. Searches official documentation
4. Combines and ranks results

## Options
- `--sources`: Comma-separated list of sources
- `--limit`: Maximum results per source
- `--recent`: Only results from last N days

## Example
```
/deep-search "react server components" --sources github,docs --recent 30
```
```

## Best Practices

### Do's
- ✅ Use relative paths
- ✅ Include examples
- ✅ Document edge cases
- ✅ Version your plugins
- ✅ Add meaningful tags

### Don'ts
- ❌ Hardcode user paths
- ❌ Include API keys
- ❌ Assume specific tools
- ❌ Create circular dependencies
- ❌ Use vague descriptions

## Testing Plugins

1. **Local Test**
   ```bash
   cp -r plugins/your-plugin ~/.claude/plugins/
   ```

2. **Validate Structure**
   ```bash
   bash scripts/validate-plugin.sh plugins/your-plugin
   ```

3. **Test in Session**
   - Start new Claude Code session
   - Try to use the plugin
   - Verify expected behavior

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Plugin not loading | Check manifest.json syntax |
| Wrong category | Verify category field matches content type |
| Not triggered | Check trigger patterns in manifest |
| File not found | Verify files field lists all required files |
