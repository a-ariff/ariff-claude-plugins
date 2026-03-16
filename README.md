# Claude Code Plugin Marketplace

<div align="center">

[![Plugins](https://img.shields.io/badge/plugins-53-blue?style=for-the-badge)](./marketplace.json)
[![Agents](https://img.shields.io/badge/agents-22-green?style=for-the-badge)](./plugins)
[![Skills](https://img.shields.io/badge/skills-26-orange?style=for-the-badge)](./plugins)
[![Hooks](https://img.shields.io/badge/hooks-3-red?style=for-the-badge)](./plugins)
[![License](https://img.shields.io/badge/license-MIT-purple?style=for-the-badge)](./LICENSE)
[![Stars](https://img.shields.io/github/stars/a-ariff/ariff-claude-plugins?style=for-the-badge)](https://github.com/a-ariff/ariff-claude-plugins/stargazers)

**53 production-ready plugins for Claude Code -- autonomous agents, power skills, smart hooks, and custom commands**

Compatible with Claude Opus 4.6, Sonnet 4.6, and Haiku 4.5

[Quick Start](#quick-start) | [What's Inside](#whats-inside) | [How to Install](#how-to-install-step-by-step) | [Usage Guide](#usage-guide) | [Documentation](#documentation) | [Contributing](#contributing)

</div>

---

## What is this?

Claude Code is Anthropic's CLI tool for coding with AI. **Plugins** extend what Claude Code can do by adding specialized agents, skills, and automation hooks.

This marketplace gives you **53 ready-to-use plugins** that turn Claude Code into an autonomous development powerhouse. Instead of telling Claude what to do step by step, you delegate entire tasks to specialized agents that know exactly how to handle them.

**Before plugins:**
```
You: "Read the auth module, check for SQL injection, review the error handling,
     look at the input validation, check the session management..."
```

**After plugins:**
```
You: "Run a security review on the auth module"
Claude: *security-analyst agent handles everything autonomously*
```

---

## Quick Start

**Prerequisites:** [Claude Code](https://claude.ai/code) installed and working.

```bash
# clone the marketplace
git clone https://github.com/a-ariff/ariff-claude-plugins.git

# install all 53 plugins
cd ariff-claude-plugins && bash scripts/install.sh
```

Done. All plugins are now available in your next Claude Code session.

---

## What's Inside

### 53 Plugins in 4 Categories

```
ariff-claude-plugins/
|
|-- 22 Agents      autonomous workers that handle entire tasks
|-- 26 Skills      methodologies and knowledge you can apply on demand
|--  3 Hooks       automatic safeguards that run without you asking
|--  2 Commands    slash commands for common workflows
```

### Agents (22) -- delegate entire tasks

Agents are autonomous workers. You give them a task, they figure out the approach, use tools, read files, and deliver results.

| Category | Agents | What they do |
|----------|--------|-------------|
| **Development** | architect, backend-dev, frontend-dev, performance-engineer, qa-engineer, security-analyst, refactorer, autonomous-dev-assistant | Build, optimize, test, and secure code |
| **Analysis** | sequential-thinker, project-planner, analyzer, mentor | Plan, analyze, reason through problems |
| **Safety** | context-validator, intent-clarifier, pre-action-verifier, scope-boundary-checker, fact-checker, dependency-validator, rollback-planner | Validate before acting, catch mistakes early |
| **Specialized** | smithery-deployment-agent, smart-routing, setup-orchestrator | Deploy MCP servers, route to optimal models, configure environments |

### Skills (26) -- apply proven methodologies

Skills are knowledge and methodology files that Claude loads when relevant. They teach Claude how to approach specific types of problems.

**Superpowers (9):** brainstorming, writing-plans, executing-plans, subagent-driven-development, verification-before-completion, root-cause-tracing, defense-in-depth, when-stuck, using-superpowers

**Development (12):** github, plugin-creator, plugin-checker, canvas-api, api-docs-generator, ci-cd-helper, code-reviewer, commit-message-generator, error-explainer, performance-optimizer, pr-analyzer, refactor-assistant

**Testing (3):** security-scanner, tdd-workflow, test-writer

**Debugging (2):** systematic-debugger, memory-sync

### Hooks (3) -- automatic safeguards

Hooks run automatically at specific points during Claude's workflow. You don't invoke them -- they watch and act.

| Hook | Event | What it does |
|------|-------|-------------|
| assumption-checker | PreToolUse | Warns when Claude makes assumptions instead of checking |
| memory-sync | Stop | Prompts to save learnings at session end |
| hooks-reference | PreToolUse | Reference implementation for building your own hooks |

### Commands (2) -- slash commands

| Command | Usage | What it does |
|---------|-------|-------------|
| deep-search | `/deep-search "query"` | Multi-source semantic search across GitHub, Reddit, docs |
| task-folder-manager | `/task-folder-manager` | Create dated, organized task folders |

---

## How to Install (Step by Step)

This guide assumes you've never installed a Claude Code plugin before.

### Step 1: Make sure Claude Code is installed

Open your terminal and run:
```bash
claude --version
```

If you see a version number (e.g., `2.1.76`), you're good. If not, install Claude Code first from [claude.ai/code](https://claude.ai/code).

### Step 2: Clone this repository

```bash
git clone https://github.com/a-ariff/ariff-claude-plugins.git
```

This downloads the entire marketplace to your machine.

### Step 3: Run the installer

```bash
cd ariff-claude-plugins
bash scripts/install.sh
```

The installer copies plugins to your `~/.claude/` directory where Claude Code can find them.

### Step 4: Verify it worked

Start a new Claude Code session:
```bash
claude
```

Then type:
```
/browse
```

You should see all 53 plugins listed. If you see them, installation is complete.

### How it works (visual guide)

```
                    YOUR MACHINE
    +------------------------------------------+
    |                                          |
    |  ariff-claude-plugins/                   |
    |  (downloaded repo)                       |
    |       |                                  |
    |       | install.sh copies to:            |
    |       v                                  |
    |  ~/.claude/                              |
    |  |-- agents/     (22 agent files)        |
    |  |-- skills/     (26 skill files)        |
    |  |-- hooks/      (3 hook configs)        |
    |  |-- commands/   (2 command files)        |
    |       |                                  |
    |       | Claude Code reads from ~/.claude |
    |       v                                  |
    |  Claude Code CLI                         |
    |  (now has 53 plugins available)          |
    |                                          |
    +------------------------------------------+
```

### Alternative: Install a single plugin

Don't want all 53? Install just what you need:
```bash
bash scripts/install.sh --plugin architect
bash scripts/install.sh --plugin security-analyst
bash scripts/install.sh --plugin systematic-debugger
```

### Updating

When new plugins are added:
```bash
cd ariff-claude-plugins
git pull origin main
bash scripts/install.sh
```

### Uninstalling

```bash
bash scripts/install.sh --uninstall
```

---

## Usage Guide

### Using Agents

Agents are the most powerful feature. Describe what you want and Claude delegates to the right agent.

**Example workflow:**

```
+-------------------+     +-------------------+     +-------------------+
|                   |     |                   |     |                   |
|  You: "review     |---->|  Claude selects   |---->|  security-analyst |
|  this code for    |     |  security-analyst |     |  reads code,      |
|  vulnerabilities" |     |  agent            |     |  checks OWASP,    |
|                   |     |                   |     |  reports findings  |
+-------------------+     +-------------------+     +-------------------+
```

More examples:
```
"Design a caching layer for my high-traffic API"
  -> architect agent handles system design

"Review this code for security vulnerabilities"
  -> security-analyst agent runs a full review

"Optimize this database query that's taking 3 seconds"
  -> performance-engineer agent profiles and fixes it

"Plan the implementation for this new feature"
  -> project-planner agent breaks it down into steps

"Help me understand how this authentication flow works"
  -> mentor agent explains at your level
```

### Using Skills

Skills are invoked when Claude recognizes a relevant situation, or you can ask directly:

```
"Use the systematic-debugger skill to find this memory leak"
"Apply the brainstorming skill to generate API design alternatives"
"Use verification-before-completion for this deployment"
```

### Using Commands

Slash commands for quick actions:

```
/deep-search "react server components best practices"
/task-folder-manager --name "feature-auth-rewrite"
```

### Using Hooks

Hooks run automatically. No action needed from you.

```
+------------------+     +--------------------+     +------------------+
|                  |     |                    |     |                  |
|  Claude is about |---->|  assumption-checker|---->|  "Warning: you   |
|  to use a tool   |     |  hook fires        |     |  assumed X, did  |
|                  |     |  (PreToolUse)      |     |  you verify it?" |
+------------------+     +--------------------+     +------------------+
```

---

## Architecture

### Plugin loading flow

```
Session Start
     |
     v
Claude Code reads ~/.claude/
     |
     +-- agents/*.md      -> loaded on demand when task matches
     +-- skills/*/SKILL.md -> descriptions loaded, full content on invoke
     +-- hooks/hooks.json  -> always active, fires on matching events
     +-- commands/*.md     -> available as /slash-commands
```

### Plugin structure

Every plugin follows this structure:
```
my-plugin/
  .claude-plugin/
    plugin.json          # manifest (name, version, description)
  agents/                # agent definitions (markdown)
  skills/                # skill definitions (markdown)
  hooks/
    hooks.json           # hook event configuration
  commands/              # slash command definitions
  scripts/               # shell scripts for hooks
```

### Supported hook events (22 total)

| Category | Events |
|----------|--------|
| Session | SessionStart, SessionEnd |
| User Input | UserPromptSubmit |
| Tool Use | PreToolUse, PostToolUse, PostToolUseFailure, PermissionRequest |
| Completion | Stop, SubagentStop, TaskCompleted, TeammateIdle |
| Context | PreCompact, PostCompact, InstructionsLoaded |
| Config | ConfigChange |
| Worktree | WorktreeCreate, WorktreeRemove |
| MCP | Elicitation, ElicitationResult |
| System | Notification |

### Compatibility

| Requirement | Details |
|-------------|---------|
| Claude Opus 4.6 | Full support (1M context) |
| Claude Sonnet 4.6 | Full support (1M context) |
| Claude Haiku 4.5 | Full support (200k context) |
| Claude Code version | 2.1+ recommended |
| Operating systems | macOS, Linux, Windows (WSL) |
| Git worktree isolation | Supported |
| MCP integration | Supported (stdio, HTTP, SSE) |

---

## Statistics

| Metric | Count |
|--------|-------|
| Total plugins | 53 |
| Agents | 22 (42%) |
| Skills | 26 (49%) |
| Hooks | 3 (5%) |
| Commands | 2 (4%) |
| Plugin component types | 7 (agents, skills, commands, hooks, MCP, LSP, output styles) |
| Supported hook events | 22 |
| Supported models | 3 (Opus 4.6, Sonnet 4.6, Haiku 4.5) |
| Install time | < 30 seconds |

---

## Documentation

- [Plugin Structure Guide](./docs/PLUGIN_STRUCTURE.md) -- how plugins work internally
- [Categories Guide](./docs/CATEGORIES.md) -- detailed breakdown of each category
- [Contributing Guide](./CONTRIBUTING.md) -- how to create your own plugins
- [Changelog](./CHANGELOG.md) -- version history
- [Quick Start](./QUICKSTART.md) -- fast setup guide
- [Setup Verification](./SETUP-COMPLETE.md) -- troubleshooting

---

## Use Cases

### For solo developers
- Delegate code reviews to the security-analyst and code-reviewer
- Use project-planner before starting any feature
- Let systematic-debugger find root causes
- Have architect agent design your system before you code

### For teams
- Standardize workflows with shared skills
- Safety checker agents catch mistakes before they ship
- QA engineer agent handles test strategy
- Plugin-creator skill helps build team-specific plugins

### For students
- Mentor agent explains concepts at your level
- Canvas API skill integrates with university LMS
- Sequential-thinker breaks complex problems into steps
- Writing-plans skill teaches you to plan before coding

---

## Contributing

Contributions welcome. See [CONTRIBUTING.md](./CONTRIBUTING.md).

**Quick contribution:**
1. Fork this repository
2. Create your plugin in `plugins/your-plugin/`
3. Run `bash scripts/validate-plugin.sh plugins/your-plugin`
4. Submit a pull request

---

## Why this marketplace?

| Feature | This marketplace | Typical repos |
|---------|-----------------|---------------|
| Production-tested | Yes, 53 plugins | 5-10 experimental plugins |
| Documentation | Full guides, visual diagrams, examples | Basic README |
| Safety layer | 7 checker agents + 3 hooks | None |
| Model support | Opus 4.6, Sonnet 4.6, Haiku 4.5 | Single model |
| One-line install | `bash scripts/install.sh` | Manual file copying |
| Cross-device sync | Git-based, works with any cloud storage | Not supported |
| Updates | `git pull && bash scripts/install.sh` | Manual |

---

## License

MIT License -- see [LICENSE](./LICENSE) for details.

---

## Links

- **Repository**: https://github.com/a-ariff/ariff-claude-plugins
- **Issues**: https://github.com/a-ariff/ariff-claude-plugins/issues
- **Author**: [@a-ariff](https://github.com/a-ariff)

---

If this marketplace is useful to you, consider giving it a star. It helps others find these plugins.
