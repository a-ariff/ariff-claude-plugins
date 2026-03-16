# Hooks Guide

## What are hooks?

Hooks are event-driven automations that run automatically without you asking. They fire at specific points in Claude's workflow and can validate, warn, or modify behavior.

Think of hooks like automated safety checks. A building inspector doesn't wait for you to call -- they show up at required checkpoints during construction.

## How hooks work

```
Claude is about to do something
     |
     v
Hook event fires (e.g., PreToolUse)
     |
     v
Hook script runs automatically
     |
     +-- Script says OK     --> Claude proceeds
     +-- Script says WARN   --> Claude sees warning, decides
     +-- Script says BLOCK  --> Claude stops, explains why
```

## You don't invoke hooks

Hooks are always active once installed. You never type "use the assumption-checker hook." It runs automatically every time Claude is about to use a tool.

## All 3 hooks

**assumption-checker**
Fires on: PreToolUse (before any tool executes)
What it does: Checks if Claude is making assumptions instead of verifying facts. Especially strict about Canvas LMS operations.
Why it matters: Prevents Claude from acting on guesses rather than verified information.

**memory-sync**
Fires on: Stop (when Claude finishes responding)
What it does: Prompts to save important learnings, preferences, and context to persistent memory.
Why it matters: Ensures valuable context isn't lost between sessions.

**hooks-reference**
Fires on: PreToolUse
What it does: Reference implementation showing how to build hooks. Includes example scripts for validation, timestamps, and context loading.
Why it matters: Template for creating your own hooks.

## Supported hook events (22 total)

Claude Code supports 22 different events you can hook into:

| Event | When it fires | Can it block? |
|-------|--------------|---------------|
| SessionStart | Session begins | No |
| SessionEnd | Session terminates | No |
| UserPromptSubmit | You send a message | Yes |
| PreToolUse | Before a tool runs | Yes |
| PostToolUse | After a tool succeeds | Feedback only |
| PostToolUseFailure | After a tool fails | No |
| PermissionRequest | Permission dialog | Yes |
| Stop | Claude finishes | Yes |
| SubagentStop | Subagent finishes | Yes |
| TaskCompleted | Task marked done | Yes |
| TeammateIdle | Agent about to idle | Yes |
| PreCompact | Before context compaction | No |
| PostCompact | After compaction | No |
| InstructionsLoaded | CLAUDE.md loaded | No |
| ConfigChange | Settings change | Yes |
| WorktreeCreate | Worktree created | Yes |
| WorktreeRemove | Worktree removed | No |
| Elicitation | MCP requests input | Yes |
| ElicitationResult | User responds to MCP | Yes |
| Notification | System notification | No |

## Hook file structure

```
plugins/assumption-checker/
  .claude-plugin/
    plugin.json
  hooks/
    hooks.json              <-- hook configuration
  scripts/
    check-assumptions.sh    <-- script that runs
```

hooks.json defines which events trigger which scripts:

```json
{
  "PreToolUse": [
    {
      "matcher": "*",
      "hooks": [
        {
          "type": "command",
          "command": "${CLAUDE_PLUGIN_ROOT}/scripts/check-assumptions.sh",
          "timeout": 10
        }
      ]
    }
  ]
}
```

## Hook handler types

| Type | How it works |
|------|-------------|
| command | Runs a shell script. Input via stdin JSON, output via exit code + stdout. |
| http | POST JSON to a URL. Response is JSON. |
| prompt | Single-turn LLM evaluation. Returns ok/not ok with reason. |
| agent | Multi-turn subagent with tool access. Returns ok/not ok with reason. |

## Creating your own hook

1. Create a hooks.json in your plugin's hooks/ directory
2. Choose the event (e.g., PreToolUse, Stop, PostToolUse)
3. Write a script or choose a handler type
4. The script receives JSON on stdin with event details
5. Exit code 0 = allow, exit code 2 = block

See the hooks-reference plugin for complete working examples.

## Tips

- Hooks add latency -- keep scripts fast (under 10 seconds)
- Use matcher to limit which tools a hook applies to (e.g., "Bash" only)
- PreToolUse is the most useful event for safety checks
- Stop is the best event for session-end cleanup
- Test hooks locally before sharing them
