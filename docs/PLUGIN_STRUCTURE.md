# Plugin Structure Guide

How Claude Code plugins are built. Read this if you want to create your own.

## Plugin directory layout

Every plugin follows this structure:

```
my-plugin/
  .claude-plugin/
    plugin.json              # required: manifest
  agents/                    # agent markdown files
    my-agent.md
  skills/                    # skill directories or flat files
    my-skill/
      SKILL.md
    or: my-skill.skill.md
  hooks/
    hooks.json               # hook event configuration
  commands/                  # command markdown files
    my-command.md
  scripts/                   # shell scripts (used by hooks)
    my-script.sh
```

You only need the directories for the plugin types you're creating. An agent-only plugin just needs `.claude-plugin/` and `agents/`.

## plugin.json (manifest)

The only required file. Tells Claude Code about the plugin.

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "What this plugin does (Claude reads this)",
  "author": {
    "name": "Your Name",
    "email": "you@example.com"
  },
  "type": "agent"
}
```

| Field | Required | Description |
|-------|----------|-------------|
| name | Yes | Kebab-case identifier |
| version | Yes | Semver (1.0.0) |
| description | Yes | One-line description |
| author | No | Name and email |
| type | No | Primary type: agent, skill, hook, command |

## Creating an agent

1. Create the directory:
```
my-agent/
  .claude-plugin/
    plugin.json
  agents/
    my-agent.md
```

2. Write plugin.json:
```json
{
  "name": "my-agent",
  "version": "1.0.0",
  "description": "What this agent does and when to use it",
  "author": { "name": "Your Name" },
  "type": "agent"
}
```

3. Write the agent markdown with frontmatter:
```markdown
---
name: my-agent
description: When to use this agent (Claude reads this to decide)
model: sonnet
---

# My Agent

You are a specialized agent for [domain].

## Your workflow
1. First, analyze the request
2. Then, gather information
3. Finally, deliver results

## What you're good at
- Specific capability 1
- Specific capability 2
```

## Creating a skill

1. Create the directory:
```
my-skill/
  .claude-plugin/
    plugin.json
  skills/
    my-skill/
      SKILL.md
```

2. Write SKILL.md with frontmatter:
```markdown
---
name: my-skill
description: What technique this teaches and when to use it
---

# My Skill

## When to use this
- Situation 1
- Situation 2

## The technique
Step-by-step methodology...
```

## Creating a hook

1. Create the directory:
```
my-hook/
  .claude-plugin/
    plugin.json
  hooks/
    hooks.json
  scripts/
    validate.sh
```

2. Write hooks.json:
```json
{
  "PreToolUse": [
    {
      "matcher": "Bash",
      "hooks": [
        {
          "type": "command",
          "command": "${CLAUDE_PLUGIN_ROOT}/scripts/validate.sh",
          "timeout": 10
        }
      ]
    }
  ]
}
```

3. Write the script:
```bash
#!/bin/bash
# Read event data from stdin
EVENT=$(cat)

# Your validation logic here
echo '{"allow": true}'
exit 0
```

## Creating a command

1. Create the directory:
```
my-command/
  .claude-plugin/
    plugin.json
  commands/
    my-command.md
```

2. Write the command markdown:
```markdown
# My Command

## Usage
/my-command <arguments>

## Instructions
When this command is invoked, do the following:
1. Step 1
2. Step 2
3. Step 3
```

## Validating your plugin

```bash
bash scripts/validate-plugin.sh plugins/my-plugin
```

## Installing locally for testing

macOS/Linux:
```bash
bash scripts/install.sh --plugin my-plugin
```

Windows PowerShell:
```powershell
.\scripts\install.ps1 -Plugin my-plugin
```

Then start a new Claude Code session and test.

## Best practices

- Keep descriptions clear -- Claude uses them to decide when to use the plugin
- One plugin per purpose -- don't bundle unrelated functionality
- Test before sharing -- validate structure and test in a real session
- No hardcoded paths -- use ${CLAUDE_PLUGIN_ROOT} for relative paths
- No secrets -- never include API keys, tokens, or passwords
