# Contributing to Ariff's Claude Code Plugins

Thank you for your interest in contributing! This guide will help you create and submit plugins.

## 🎯 Before You Start

1. Check existing plugins to avoid duplicates
2. Review the [Plugin Structure](#plugin-structure) requirements
3. Test your plugin locally before submitting

## 📁 Plugin Structure

Every plugin must include:

```
plugins/your-plugin/
├── manifest.json        # Required: Plugin metadata
├── your-plugin.md       # Required: Main plugin file
└── README.md            # Recommended: Documentation
```

### manifest.json

```json
{
  "name": "your-plugin",
  "version": "1.0.0",
  "description": "Clear, concise description of what your plugin does",
  "category": "agents",
  "tags": ["relevant", "tags"],
  "author": {
    "name": "Your Name",
    "github": "your-username"
  },
  "files": ["your-plugin.md"],
  "dependencies": [],
  "claude_code_version": ">=1.0.0"
}
```

### Categories

| Category | File Extension | Description |
|----------|---------------|-------------|
| `agents` | `.agent.md` or `.md` | Autonomous task specialists |
| `skills` | `.skill.md` or `.md` | Reusable capabilities |
| `hooks` | `.hook.md` or `.md` | Event-driven automations |
| `commands` | `.command.md` or `.md` | Custom slash commands |

## ✍️ Writing Guidelines

### For Agents

```markdown
---
name: your-agent
type: agent
description: What this agent specializes in
triggers:
  - keyword patterns that activate this agent
---

# Your Agent Name

## Role
Define the agent's primary role and expertise.

## Capabilities
- List specific capabilities
- Include tools it can use
- Mention any MCP integrations

## Workflow
1. Step-by-step process
2. How it handles tasks
3. Output format

## Examples
Show example interactions.
```

### For Skills

```markdown
---
name: your-skill
type: skill
description: What capability this adds
---

# Your Skill Name

## Purpose
Why this skill exists and when to use it.

## Technique
Detailed methodology or approach.

## Application
How to apply this skill in practice.

## Examples
Real-world usage examples.
```

### For Hooks

```markdown
---
name: your-hook
type: hook
trigger: pre-tool-call|post-response|on-error
---

# Your Hook Name

## Trigger Conditions
When this hook activates.

## Actions
What the hook does when triggered.

## Configuration
Any configurable options.
```

## 🧪 Testing Your Plugin

1. **Local Testing**
   ```bash
   # Copy to your Claude directory
   cp -r plugins/your-plugin ~/.claude/plugins/
   
   # Start a new Claude Code session and test
   ```

2. **Validation**
   ```bash
   # Run the plugin checker
   bash scripts/validate-plugin.sh plugins/your-plugin
   ```

3. **Checklist**
   - [ ] manifest.json is valid JSON
   - [ ] All referenced files exist
   - [ ] No absolute paths in plugin files
   - [ ] Works in a fresh Claude Code session
   - [ ] Doesn't conflict with existing plugins

## 📤 Submitting Your Plugin

1. **Fork this repository**

2. **Create a branch**
   ```bash
   git checkout -b add-your-plugin-name
   ```

3. **Add your plugin**
   ```bash
   mkdir -p plugins/your-plugin
   # Add manifest.json, your-plugin.md, README.md
   ```

4. **Update marketplace.json**
   ```json
   {
     "name": "your-plugin",
     "source": "./plugins/your-plugin",
     "description": "Your description",
     "version": "1.0.0",
     "category": "agents|skills|hooks|commands",
     "tags": ["tag1", "tag2"]
   }
   ```

5. **Commit and push**
   ```bash
   git add .
   git commit -m "add your-plugin: brief description"
   git push origin add-your-plugin-name
   ```

6. **Open a Pull Request**
   - Use the PR template
   - Include testing evidence
   - Describe use cases

## 🏷️ Naming Conventions

- **Plugin names**: lowercase with hyphens (`my-awesome-plugin`)
- **Files**: match plugin name (`my-awesome-plugin.md`)
- **Tags**: lowercase, relevant keywords
- **Versions**: Semantic versioning (`1.0.0`)

## ⚠️ Things to Avoid

- ❌ Hardcoded paths (`/Users/yourname/...`)
- ❌ API keys or secrets
- ❌ Dependencies on non-public tools
- ❌ Overly broad or vague descriptions
- ❌ Duplicate functionality of existing plugins
- ❌ Breaking changes without version bump

## 🎖️ Recognition

Contributors are recognized in:
- Plugin manifest author field
- README acknowledgments section
- GitHub contributors list

## ❓ Questions?

- Open an issue for general questions
- Tag `@a-ariff` for specific guidance
- Check existing issues before creating new ones

---

Thank you for contributing to the Claude Code ecosystem! 🚀
