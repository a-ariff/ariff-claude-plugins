# Agents Guide

## What are agents?

Agents are autonomous AI workers with specialized expertise. When you describe a task, Claude selects the right agent and delegates the work. The agent reads files, runs commands, analyzes code, and delivers results without you directing every step.

Think of agents like team members with different job titles. You don't tell the security analyst how to do a security review -- you say "review this code for vulnerabilities" and they handle it.

## How agents work

```
You describe a task
     |
     v
Claude reads agent descriptions
     |
     v
Picks the best match
     |
     v
Agent takes over:
  - Reads relevant code
  - Uses tools (Bash, Grep, Read, Edit)
  - Applies domain knowledge
  - Returns structured results
     |
     v
You get the output
```

## How to use agents

You don't need special syntax. Just describe what you want in plain language:

```
"Review this code for security vulnerabilities"
  -> security-analyst agent

"Design a caching layer for my API"
  -> architect agent

"This function is slow, optimize it"
  -> performance-engineer agent

"Help me understand how this auth flow works"
  -> mentor agent

"Plan the implementation for user notifications"
  -> project-planner agent

"Find the root cause of this memory leak"
  -> sequential-thinker agent
```

Claude picks the agent based on the task description. You can also be explicit:

```
"Use the qa-engineer agent to create a test plan for the payment module"
```

## All 22 agents

### Development agents (8)

These agents write, optimize, and fix code.

**architect**
System design specialist. Use for designing APIs, microservices, database schemas, and making architectural decisions. Considers scalability, maintainability, and trade-offs.

Example: "Design a notification system that handles email, SMS, and push notifications"

**backend-dev**
Server-side development. Use for building APIs, database queries, authentication flows, and server logic. Knows REST, GraphQL, SQL, and common backend frameworks.

Example: "Build a REST endpoint for user registration with email verification"

**frontend-dev**
UI/UX implementation. Use for React components, state management, CSS layouts, and accessibility. Knows modern frontend patterns and responsive design.

Example: "Create a dashboard component with real-time data updates"

**performance-engineer**
Optimization specialist. Use for profiling slow code, reducing memory usage, optimizing queries, and improving load times. Finds bottlenecks systematically.

Example: "This API endpoint takes 3 seconds, find and fix the bottleneck"

**qa-engineer**
Testing specialist. Use for test strategy, writing test suites, integration tests, and ensuring code quality. Knows TDD, BDD, and testing best practices.

Example: "Create a comprehensive test plan for the checkout flow"

**security-analyst**
Security specialist. Use for vulnerability assessment, threat modeling (STRIDE), secure code review, and OWASP top 10 checks. Identifies attack vectors and recommends fixes.

Example: "Check this authentication module for security vulnerabilities"

**refactorer**
Code cleanup specialist. Use for reducing technical debt, improving readability, extracting abstractions, and simplifying complex code without changing behavior.

Example: "This 500-line function needs to be broken up into smaller pieces"

**autonomous-dev-assistant**
General-purpose development agent. Use when the task doesn't fit a specific specialist. Handles git operations, file management, and general coding tasks autonomously.

Example: "Add dark mode support to the settings page and commit the changes"

### Analysis agents (4)

These agents think, plan, and explain.

**sequential-thinker**
Step-by-step reasoning. Use for complex problems that need structured thinking. Breaks problems into logical steps, considers edge cases, and traces through logic carefully.

Example: "Walk me through why this race condition happens and how to fix it"

**project-planner**
Project planning. Use before starting any feature. Analyzes requirements, identifies dependencies, assesses risks, and creates a detailed execution plan with milestones.

Example: "Plan the implementation of a real-time chat feature"

**analyzer**
Code and system analysis. Use for understanding codebases, measuring complexity, finding patterns, and generating insights about code quality and structure.

Example: "Analyze this codebase and tell me where the technical debt is"

**mentor**
Learning guide. Use when you want to understand concepts, not just get code. Explains at your level, uses analogies, suggests learning paths, and teaches best practices.

Example: "Explain how OAuth 2.0 works, I'm new to authentication"

### Safety checker agents (7)

These agents prevent mistakes. They validate before Claude acts.

**context-validator**
Checks that Claude has enough context before making changes. Prevents acting on incomplete information.

**intent-clarifier**
Clarifies what you actually want before Claude starts working. Prevents misunderstandings on ambiguous requests.

**pre-action-verifier**
Verifies prerequisites are met before taking action. Prevents errors from missing dependencies or wrong state.

**scope-boundary-checker**
Ensures changes stay within the requested scope. Prevents accidental modifications to unrelated code.

**fact-checker**
Verifies claims against the actual codebase. Prevents Claude from making assumptions about code that isn't true.

**dependency-validator**
Validates package dependencies before changes. Prevents version conflicts, missing packages, and incompatible upgrades.

**rollback-planner**
Plans how to undo changes before making them. Ensures every action has a safe rollback path.

### Specialized agents (3)

**smithery-deployment-agent**
Deploys MCP servers to Smithery. Handles Cloudflare worker deployment, OAuth configuration, and server management.

**smart-routing**
Routes tasks to the optimal Claude model. Uses Opus for complex reasoning, Sonnet for general tasks, Haiku for quick lookups.

**setup-orchestrator**
Project setup and environment configuration. Handles initial project scaffolding, dependency installation, and environment setup.

## Agent file structure

Each agent is a markdown file in the `agents/` directory:

```
plugins/security-analyst/
  .claude-plugin/
    plugin.json
  agents/
    security-analyst.md     <-- this is the agent definition
```

The markdown file has YAML frontmatter and instructions:

```markdown
---
name: security-analyst
description: When to use this agent (Claude reads this to decide)
model: sonnet
---

# Security Analyst Agent

You are a specialized security analyst...

## Your workflow
1. First step
2. Second step
...
```

## Frontmatter fields

| Field | Required | What it does |
|-------|----------|-------------|
| name | Yes | Agent identifier (lowercase, hyphens) |
| description | Yes | Claude reads this to decide when to use the agent |
| model | No | Which Claude model to use (opus, sonnet, haiku) |
| tools | No | Restrict which tools the agent can use |
| isolation | No | Set to "worktree" for isolated git worktree |
| background | No | Set to true to run in background |
| memory | No | Enable cross-session memory (user, project, local) |

## Tips for using agents effectively

- Be specific about what you want: "review for SQL injection" is better than "review this code"
- Let the agent finish before interrupting -- they work in multiple steps
- If the wrong agent is selected, be explicit: "use the architect agent for this"
- Checker agents work automatically in the background -- you don't need to invoke them
- Combine agents: "have the architect design it, then the qa-engineer create tests for it"
