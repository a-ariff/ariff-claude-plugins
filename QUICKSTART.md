# 🚀 Quickstart Guide

Complete these steps to publish your marketplace:

## Step 1: Copy Plugins (1 minute)

Run the migration script to copy all 41 plugins:

```bash
cd /Users/ariff/Library/CloudStorage/OneDrive-Independent/dev-terminal/ariff-claude-plugins
chmod +x scripts/*.sh
bash scripts/migrate-from-config.sh
```

## Step 2: Create GitHub Repository

1. Go to [github.com/new](https://github.com/new)
2. Repository name: `ariff-claude-plugins`
3. Description: `🔌 Claude Code Plugin Marketplace - 41 production-ready agents, skills, hooks, and commands`
4. Visibility: **Public** ✓
5. Do NOT initialize with README (we already have one)
6. Click **Create repository**

## Step 3: Push to GitHub

```bash
cd /Users/ariff/Library/CloudStorage/OneDrive-Independent/dev-terminal/ariff-claude-plugins

# Initialize git
git init
git add .
git commit -m "initial commit: 41 claude code plugins"

# Connect to GitHub
git remote add origin https://github.com/a-ariff/ariff-claude-plugins.git
git branch -M main
git push -u origin main
```

## Step 4: Setup Repository Link

Link your private config to pull from marketplace:

```bash
bash scripts/setup-repo-link.sh
```

## Verify

Your marketplace is live at:
- **Repository**: https://github.com/a-ariff/ariff-claude-plugins
- **Install**: `git clone https://github.com/a-ariff/ariff-claude-plugins.git && cd ariff-claude-plugins && bash scripts/install.sh`

## 3-Repo Architecture Complete!

```
┌─────────────────────────────────────────────────────────────────┐
│                     Your Repository Setup                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────────┐     ┌──────────────────────┐          │
│  │ ariff-claude-plugins │     │  Ariff-code-config   │          │
│  │      (PUBLIC)        │────▶│     (PRIVATE)        │          │
│  │  41 shareable plugins│     │  Personal settings   │          │
│  └──────────────────────┘     └──────────────────────┘          │
│           │                            │                         │
│           │                            │                         │
│           ▼                            ▼                         │
│  ┌──────────────────────────────────────────────────┐           │
│  │              ~/.claude/ (installed)               │           │
│  │  • agents/   • skills/   • hooks/   • commands/  │           │
│  └──────────────────────────────────────────────────┘           │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## What Each Repo Contains

| Repo | Visibility | Contents |
|------|------------|----------|
| **ariff-claude-plugins** | Public | 41 plugins, docs, install script |
| **Ariff-code-config** | Private | MCP configs, credentials, personal settings |

## Cross-Device Sync

Both repos sync via OneDrive:
```
OneDrive/dev-terminal/
├── ariff-claude-plugins/    # Public marketplace
└── Ariff-code-config/       # Private config
```

## Next Steps

1. ✅ Marketplace created
2. ⬜ Share on social media
3. ⬜ Add to awesome-claude-code lists
4. ⬜ Accept community contributions
