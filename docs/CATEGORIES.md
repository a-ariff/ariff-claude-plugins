# Plugin Categories

This document explains the different plugin categories and when to use each.

## Overview

```
┌──────────────────────────────────────────────────────────────┐
│                    Claude Code Plugins                        │
├──────────────┬──────────────┬──────────────┬─────────────────┤
│   Agents     │    Skills    │    Hooks     │    Commands     │
│  (21 total)  │  (15 total)  │   (2 total)  │   (2 total)     │
├──────────────┼──────────────┼──────────────┼─────────────────┤
│ Autonomous   │  Reusable    │   Event      │   User          │
│ specialists  │  techniques  │   driven     │   triggered     │
└──────────────┴──────────────┴──────────────┴─────────────────┘
```

## Agents (21)

### What They Are
Autonomous AI personas with specialized expertise. Each agent has:
- A defined role and responsibility
- Specific capabilities and tools
- A consistent workflow approach

### When to Use
- When you need domain expertise
- For complex multi-step tasks
- When delegation improves quality

### How to Invoke
```
@architect-agent Design a scalable API
@security-analyst Review this code for vulnerabilities
```

### Sub-Categories

#### Development Agents (8)
| Agent | Specialty |
|-------|-----------|
| architect-agent | System design |
| backend-dev | Server-side code |
| frontend-dev | UI implementation |
| performance-engineer | Optimization |
| qa-engineer | Testing |
| refactorer | Code cleanup |
| security-analyst | Security review |
| autonomous-dev-assistant | Independent tasks |

#### Analysis Agents (4)
| Agent | Specialty |
|-------|-----------|
| sequential-thinker | Step-by-step reasoning |
| project-planner | Task breakdown |
| analyzer | Code analysis |
| mentor | Learning guidance |

#### Checker Agents (7)
Safety-first validation before actions.

| Agent | What It Checks |
|-------|----------------|
| context-validator | Context completeness |
| intent-clarifier | User intent |
| pre-action-verifier | Prerequisites |
| scope-boundary-checker | Scope limits |
| fact-checker | Codebase facts |
| dependency-validator | Package deps |
| rollback-planner | Undo strategies |

#### Specialized Agents (2)
| Agent | Purpose |
|-------|---------|
| smithery-deployment-agent | MCP deployment |
| smart-routing | Model selection |

## Skills (15)

### What They Are
Reusable techniques and methodologies that Claude can apply. Skills are:
- Documented approaches
- Transferable across contexts
- Combinable with each other

### When to Use
- For specific techniques (debugging, planning)
- When methodology matters
- For consistent quality approaches

### How to Invoke
```
Use the systematic-debugging skill to find this bug
Apply the brainstorming skill to generate ideas
```

### Sub-Categories

#### Superpowers (10)
Enhanced capabilities for complex tasks.

| Skill | Capability |
|-------|------------|
| using-superpowers | Meta-skill activation |
| brainstorming | Structured ideation |
| writing-plans | Plan creation |
| executing-plans | Plan execution |
| subagent-driven-development | Task delegation |
| verification-before-completion | Quality checks |
| root-cause-tracing | Deep analysis |
| defense-in-depth | Multi-layer validation |
| systematic-debugging | Bug investigation |
| when-stuck | Unblocking techniques |

#### Development Skills (3)
| Skill | Purpose |
|-------|---------|
| github-operations | Git/GitHub workflows |
| plugin-creator | Plugin development |
| plugin-checker | Plugin validation |

#### Reference Skills (2)
| Skill | Content |
|-------|---------|
| hooks-reference | Hook patterns |
| canvas-api | Canvas LMS integration |

## Hooks (2)

### What They Are
Event-driven automations that trigger automatically. Hooks:
- Run on specific lifecycle events
- Require no manual invocation
- Add safety and automation

### When They Trigger
| Event | When |
|-------|------|
| `pre-tool-call` | Before any tool executes |
| `post-response` | After Claude responds |
| `on-error` | When errors occur |

### Current Hooks
| Hook | Trigger | Purpose |
|------|---------|---------|
| assumption-checker | pre-tool-call | Validates assumptions |
| memory-sync | post-response | Syncs learnings |

## Commands (2)

### What They Are
Custom slash commands for specific workflows. Commands:
- Are user-initiated
- Perform specific actions
- Have defined parameters

### How to Use
```
/deep-search "react hooks" --sources github,docs
/task-folder-manager --name "new-feature"
```

### Current Commands
| Command | Purpose |
|---------|---------|
| deep-search | Multi-source search |
| task-folder-manager | Folder organization |

## Choosing the Right Type

```
                    ┌─────────────────┐
                    │  Need something │
                    │     done?       │
                    └────────┬────────┘
                             │
              ┌──────────────┼──────────────┐
              ▼              ▼              ▼
        ┌──────────┐  ┌───────────┐  ┌───────────┐
        │ Complex  │  │ Specific  │  │  Simple   │
        │ multi-   │  │ technique │  │  action   │
        │ step?    │  │ needed?   │  │           │
        └────┬─────┘  └─────┬─────┘  └─────┬─────┘
             │              │              │
             ▼              ▼              ▼
        ┌──────────┐  ┌───────────┐  ┌───────────┐
        │  AGENT   │  │   SKILL   │  │  COMMAND  │
        └──────────┘  └───────────┘  └───────────┘

                    ┌─────────────────┐
                    │  Automatic?     │
                    │  (no trigger)   │
                    └────────┬────────┘
                             │
                             ▼
                        ┌──────────┐
                        │   HOOK   │
                        └──────────┘
```

## Combining Plugins

Plugins work best together:

```
User: @architect-agent Design a caching layer

Architect Agent:
├── Uses brainstorming skill for options
├── Triggers assumption-checker hook
├── Applies writing-plans skill
└── Suggests @performance-engineer for review
```

## Summary Table

| Aspect | Agents | Skills | Hooks | Commands |
|--------|--------|--------|-------|----------|
| **Trigger** | @mention | Reference | Automatic | /slash |
| **Autonomy** | High | Medium | Automatic | User-driven |
| **Scope** | Domain | Technique | Event | Action |
| **Reusable** | Yes | Yes | N/A | Yes |
| **Combinable** | Yes | Yes | Limited | Limited |
| **Count** | 21 | 15 | 2 | 2 |
