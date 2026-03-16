# Commands Guide

## What are commands?

Commands are custom slash commands that you invoke manually. They're the simplest plugin type -- you type a command, Claude follows the instructions in the command file.

Think of commands like keyboard shortcuts. You press the shortcut, it does a specific thing.

## How commands work

```
You type: /deep-search "react hooks"
     |
     v
Claude loads deep-search.md from commands/
     |
     v
Follows the instructions in the file
     |
     v
Returns results
```

## How to use commands

Type the command with a forward slash:

```
/deep-search "kubernetes networking"
/task-folder-manager --name "feature-auth"
```

## All 2 commands

**deep-search**
Multi-source semantic search. Searches GitHub, Reddit, vendor docs, Stack Overflow, and more. Automatically detects the topic and routes to the most relevant sources.

Usage:
```
/deep-search "react server components best practices"
/deep-search "kubernetes pod networking troubleshooting"
/deep-search "postgres query optimization"
```

What it does:
1. Analyzes your query to detect topics, technologies, and vendors
2. Selects the best sources for that topic
3. Searches each source
4. Combines and summarizes results

**task-folder-manager**
Creates dated, organized task folders. Useful for keeping work organized by date and task name.

Usage:
```
/task-folder-manager --name "feature-auth-rewrite"
/task-folder-manager --name "bug-fix-payment"
```

What it does:
1. Creates a folder with today's date and your task name
2. Sets up standard subfolders for documentation
3. Creates initial files for tracking progress

## Command file structure

```
plugins/deep-search/
  .claude-plugin/
    plugin.json
  commands/
    deep-search.md          <-- command definition
```

The markdown file contains instructions Claude follows when the command is invoked:

```markdown
# Deep Search Command

Intelligent search across multiple sources...

## Usage
/deep-search <query>

## How It Works
1. Analyze query
2. Route to sources
3. Execute search
4. Synthesize results
```

## Creating your own command

1. Create a commands/ directory in your plugin
2. Add a .md file named after your command
3. Write clear instructions for what the command should do
4. Add to plugin.json

Commands are the simplest plugin type to create. If you're new to plugin development, start here.

## Difference between commands and skills

| Feature | Commands | Skills |
|---------|----------|--------|
| How to invoke | /slash-command | Reference by name |
| Complexity | Simple, single action | Complex methodology |
| Context | Loaded immediately | Loaded on demand |
| Best for | Quick actions, searches | Techniques, workflows |
