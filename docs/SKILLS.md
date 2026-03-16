# Skills Guide

## What are skills?

Skills are methodology and knowledge files that teach Claude how to approach specific types of problems. Unlike agents (which are autonomous workers), skills are techniques that Claude applies within your conversation.

Think of the difference like this:
- **Agent:** "Hire a security consultant to review the code" (they do it independently)
- **Skill:** "Use this debugging checklist while you fix the bug" (you apply the technique)

## How skills work

```
Claude receives your request
     |
     v
Checks if any skill matches
     |
     v
Loads the skill's methodology
     |
     v
Applies the technique to your task
     |
     v
You get results following that methodology
```

Skills are loaded into Claude's context on demand. Only the skill description is loaded at startup (to save context window). The full content loads when the skill is actually invoked.

## How to use skills

Reference the skill by name in your message:

```
"Use the systematic-debugger skill to investigate this crash"
"Apply the brainstorming skill to come up with API design options"
"Use the tdd-workflow skill for this new feature"
```

Or use the slash command shortcut if the skill supports it:

```
/deep-search "react hooks best practices"
```

## All 26 skills

### Superpowers (9)

Advanced methodologies for complex work.

**brainstorming**
Structured idea generation. Use when you need creative options before committing to a direction. Generates multiple approaches, evaluates trade-offs, and helps you pick the best one.

Example: "Apply brainstorming to come up with 5 different approaches for the caching layer"

**writing-plans**
Implementation planning. Use before starting any non-trivial feature. Creates step-by-step plans with dependencies, risks, and verification criteria.

Example: "Use writing-plans to create an implementation plan for the notification system"

**executing-plans**
Plan execution with checkpoints. Use when following an existing plan. Tracks progress, verifies each step, and adjusts when things change.

Example: "Use executing-plans to implement the notification system plan we created"

**subagent-driven-development**
Task delegation patterns. Use for large tasks that benefit from parallel work. Breaks work into subtasks and delegates to specialized subagents.

Example: "Use subagent-driven-development to implement both the API and frontend in parallel"

**verification-before-completion**
Pre-delivery quality check. Use before marking any task as done. Runs through a verification checklist to catch issues before you ship.

Example: "Apply verification-before-completion to check this PR is ready to merge"

**root-cause-tracing**
Deep analysis for finding why problems happen. Use for bugs that seem mysterious or keep coming back. Traces through the full chain of causation.

Example: "Use root-cause-tracing to find why users are getting logged out randomly"

**defense-in-depth**
Multi-layer validation. Use when you need extra confidence that something is correct. Applies multiple independent checks from different angles.

Example: "Apply defense-in-depth to validate this database migration won't lose data"

**when-stuck**
Techniques for getting unstuck. Use when you've been going in circles or hit a wall. Provides systematic approaches to break through blockers.

Example: "I've been stuck on this bug for an hour, use the when-stuck skill"

**using-superpowers**
Meta-skill that helps you discover and combine other skills. Use when you're not sure which skill to apply. Recommends the right approach for your situation.

Example: "What superpowers should I use for this refactoring project?"

### Development skills (12)

Practical tools for everyday development work.

**github**
Git and GitHub workflow best practices. Covers branching strategies, PR reviews, commit messages, and GitHub Actions.

Example: "Use the github skill to set up a proper branching strategy"

**plugin-creator**
Guide for creating new Claude Code plugins. Walks through the full process from concept to working plugin.

Example: "Use plugin-creator to help me build a custom database agent"

**plugin-checker**
Plugin validation and quality checks. Verifies structure, manifest, and content quality.

Example: "Use plugin-checker to validate my new plugin before publishing"

**canvas-api**
Canvas LMS API integration guide. Covers authentication, endpoints, and MCP tools for university course management.

Example: "Use the canvas-api skill to fetch my course assignments"

**api-docs-generator**
Generate API documentation from code. Reads endpoints, parameters, and responses to create comprehensive docs.

Example: "Generate API docs for all the endpoints in the /api directory"

**ci-cd-helper**
CI/CD pipeline configuration. Helps set up and troubleshoot GitHub Actions, deployment pipelines, and automated testing.

Example: "Use ci-cd-helper to create a GitHub Actions workflow for this project"

**code-reviewer**
Comprehensive code review. Checks for bugs, performance issues, security concerns, and code style.

Example: "Apply the code-reviewer skill to review this pull request"

**commit-message-generator**
Generate meaningful commit messages. Analyzes staged changes and creates clear, descriptive messages.

Example: "Use commit-message-generator to write a commit message for these changes"

**error-explainer**
Explain errors and suggest fixes. Takes error messages and stack traces, explains what went wrong in plain language, and suggests solutions.

Example: "Explain this error and how to fix it: [paste error]"

**performance-optimizer**
Code performance optimization techniques. Covers profiling, caching, query optimization, and common bottlenecks.

Example: "Apply performance-optimizer techniques to speed up this data processing"

**pr-analyzer**
Pull request analysis. Reviews PR changes, identifies risks, suggests improvements, and checks for common issues.

Example: "Analyze PR #42 and give me a review summary"

**refactor-assistant**
Code refactoring patterns and guidance. Covers extract method, rename, move, and other refactoring operations with examples.

Example: "Use refactor-assistant to clean up this service class"

### Testing skills (3)

**security-scanner**
Security vulnerability scanning. Checks for OWASP top 10, dependency vulnerabilities, and insecure configurations.

Example: "Run the security-scanner skill on the authentication module"

**tdd-workflow**
Test-driven development workflow. Guides you through the red-green-refactor cycle with practical steps.

Example: "Use tdd-workflow to implement this new feature test-first"

**test-writer**
Automated test generation. Reads your code and generates unit tests, integration tests, and edge case tests.

Example: "Use test-writer to generate tests for the payment service"

### Debugging skills (2)

**systematic-debugger**
Structured debugging methodology. Scientific approach to finding bugs: reproduce, isolate, identify, fix. Prevents random code changes.

Example: "Use systematic-debugger to investigate why the upload fails on large files"

**memory-sync**
Session learning persistence. Prompts you to save important learnings, preferences, and context at session end.

## Skill file structure

Each skill is a directory with a SKILL.md file:

```
plugins/systematic-debugger/
  .claude-plugin/
    plugin.json
  skills/
    systematic-debugger/
      SKILL.md              <-- main skill file
```

Or a flat .md file:

```
plugins/code-reviewer/
  .claude-plugin/
    plugin.json
  skills/
    code-reviewer.skill.md  <-- flat format also works
```

## Frontmatter fields

| Field | Required | What it does |
|-------|----------|-------------|
| name | No | Skill identifier (defaults to directory name) |
| description | Yes | Claude reads this to decide when to load the skill |
| allowed-tools | No | Restrict which tools the skill can use |
| model | No | Which Claude model to use |
| user-invocable | No | Set false to hide from /slash menu |
| argument-hint | No | Autocomplete hint for arguments |

## Tips for using skills effectively

- Skills combine well: use brainstorming to explore options, then writing-plans to plan the winner
- You can use multiple skills in one conversation
- If a skill isn't being auto-detected, reference it by name explicitly
- Skills work alongside agents: an agent can use skills internally
- Superpowers are the most broadly useful -- start there
