# Quick Start

Get all 65 plugins running in under a minute.

## macOS / Linux

```bash
git clone https://github.com/a-ariff/ariff-claude-plugins.git
cd ariff-claude-plugins
bash scripts/install.sh
```

## Windows (PowerShell)

```powershell
git clone https://github.com/a-ariff/ariff-claude-plugins.git
cd ariff-claude-plugins
.\scripts\install.ps1
```

## Windows (WSL / Git Bash)

```bash
git clone https://github.com/a-ariff/ariff-claude-plugins.git
cd ariff-claude-plugins
bash scripts/install.sh
```

## Verify

```
claude
```

Then type `/browse` -- you should see all 65 plugins.

## Install a single plugin

```bash
# macOS / Linux
bash scripts/install.sh --plugin architect

# Windows PowerShell
.\scripts\install.ps1 -Plugin architect
```

## Uninstall

```bash
# macOS / Linux
bash scripts/install.sh --uninstall

# Windows PowerShell
.\scripts\install.ps1 -Uninstall
```

## What you get

```
~/.claude/                    (macOS/Linux)
%USERPROFILE%\.claude\        (Windows)

  agents/      22 autonomous agents
  skills/      26 methodology skills
  hooks/        3 automatic safeguards
  commands/     2 slash commands
  scripts/      hook support scripts
```

## Need more details?

See the full [README](./README.md) for:

- Step-by-step guide for every platform
- How each plugin type works
- Usage examples
- Troubleshooting
