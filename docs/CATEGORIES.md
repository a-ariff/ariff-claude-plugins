# Plugin Categories

Quick reference for choosing the right plugin type.

## Decision guide

```
What do you need?

Complex task, delegate entirely     --> Use an AGENT
Specific technique or methodology   --> Use a SKILL
Automatic safety check              --> Use a HOOK (always active)
Quick action via /command           --> Use a COMMAND
```

## At a glance

| Type | Count | How to use | Autonomy | Example |
|------|-------|-----------|----------|---------|
| Agent | 22 | Describe the task | High -- works independently | "Review this for vulnerabilities" |
| Skill | 26 | Reference by name | Medium -- enhances your conversation | "Use systematic-debugger skill" |
| Hook | 3 | Automatic | Automatic -- no action needed | Fires on every tool use |
| Command | 2 | /slash-command | User-triggered | /deep-search "query" |

## Detailed guides

- [Agents Guide](./AGENTS.md) -- all 22 agents with descriptions and examples
- [Skills Guide](./SKILLS.md) -- all 26 skills with descriptions and examples
- [Hooks Guide](./HOOKS.md) -- all 3 hooks, 22 supported events, how to create your own
- [Commands Guide](./COMMANDS.md) -- all 2 commands with usage
- [Plugin Structure](./PLUGIN_STRUCTURE.md) -- how to create your own plugins

## Combining plugins

Plugins work together:

```
You: "Plan and implement a notification system"

  project-planner agent    -> creates the plan
  writing-plans skill      -> structures the plan properly
  architect agent          -> designs the architecture
  backend-dev agent        -> implements the API
  test-writer skill        -> generates tests
  qa-engineer agent        -> validates quality
  security-analyst agent   -> checks for vulnerabilities
  assumption-checker hook  -> validates at every step (automatic)
```
