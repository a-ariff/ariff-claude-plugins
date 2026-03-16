# =============================================================================
# Ariff's Claude Code Plugin Installer (Windows PowerShell)
# =============================================================================
# Usage:
#   .\install.ps1                        # Install all plugins
#   .\install.ps1 -Plugin architect      # Install specific plugin
#   .\install.ps1 -List                  # List available plugins
#   .\install.ps1 -Uninstall             # Remove all plugins
# =============================================================================

param(
    [string]$Plugin,
    [switch]$List,
    [switch]$Uninstall,
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

# Paths
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$PluginsSource = Join-Path $RepoRoot "plugins"
$ClaudeDir = Join-Path $env:USERPROFILE ".claude"

function Write-Header {
    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Blue
    Write-Host "  Claude Code Plugin Installer (Windows)" -ForegroundColor Blue
    Write-Host "  53 plugins: 22 agents, 26 skills, 3 hooks, 2 commands" -ForegroundColor Blue
    Write-Host "============================================================" -ForegroundColor Blue
    Write-Host ""
}

function Write-Ok { param([string]$Msg) Write-Host "  ok  $Msg" -ForegroundColor Green }
function Write-Warn { param([string]$Msg) Write-Host "  !!  $Msg" -ForegroundColor Yellow }
function Write-Err { param([string]$Msg) Write-Host "  xx  $Msg" -ForegroundColor Red }
function Write-Info { param([string]$Msg) Write-Host "  --  $Msg" -ForegroundColor Cyan }

function Get-PluginCategory {
    param([string]$PluginDir)
    if (Test-Path (Join-Path $PluginDir "agents")) { return "agents" }
    if (Test-Path (Join-Path $PluginDir "hooks\hooks.json")) { return "hooks" }
    if (Test-Path (Join-Path $PluginDir "commands")) { return "commands" }
    if (Test-Path (Join-Path $PluginDir "skills")) { return "skills" }
    return "plugins"
}

function Install-SinglePlugin {
    param([string]$PluginName)

    $sourceDir = Join-Path $PluginsSource $PluginName
    if (-not (Test-Path $sourceDir)) {
        Write-Err "Plugin not found: $PluginName"
        return $false
    }

    $category = Get-PluginCategory $sourceDir

    # Agents
    $agentsDir = Join-Path $sourceDir "agents"
    if (Test-Path $agentsDir) {
        $dest = Join-Path $ClaudeDir "agents"
        New-Item -ItemType Directory -Force -Path $dest | Out-Null
        Get-ChildItem "$agentsDir\*.md" -ErrorAction SilentlyContinue | ForEach-Object {
            Copy-Item $_.FullName $dest -Force
        }
    }

    # Skills (directories)
    $skillsDir = Join-Path $sourceDir "skills"
    if (Test-Path $skillsDir) {
        Get-ChildItem $skillsDir -Directory -ErrorAction SilentlyContinue | ForEach-Object {
            $dest = Join-Path $ClaudeDir "skills\$($_.Name)"
            New-Item -ItemType Directory -Force -Path $dest | Out-Null
            Copy-Item "$($_.FullName)\*" $dest -Force -ErrorAction SilentlyContinue
        }
        # Skills (flat .md files)
        Get-ChildItem "$skillsDir\*.md" -ErrorAction SilentlyContinue | ForEach-Object {
            $skillName = $_.BaseName -replace '\.skill$', ''
            $dest = Join-Path $ClaudeDir "skills\$skillName"
            New-Item -ItemType Directory -Force -Path $dest | Out-Null
            Copy-Item $_.FullName (Join-Path $dest "SKILL.md") -Force
        }
    }

    # Hooks
    $hooksFile = Join-Path $sourceDir "hooks\hooks.json"
    if (Test-Path $hooksFile) {
        $dest = Join-Path $ClaudeDir "hooks"
        New-Item -ItemType Directory -Force -Path $dest | Out-Null
        Copy-Item $hooksFile (Join-Path $dest "$PluginName-hooks.json") -Force
    }

    # Commands
    $commandsDir = Join-Path $sourceDir "commands"
    if (Test-Path $commandsDir) {
        $dest = Join-Path $ClaudeDir "commands"
        New-Item -ItemType Directory -Force -Path $dest | Out-Null
        Get-ChildItem "$commandsDir\*.md" -ErrorAction SilentlyContinue | ForEach-Object {
            Copy-Item $_.FullName $dest -Force
        }
    }

    # Scripts
    $scriptsDir = Join-Path $sourceDir "scripts"
    if (Test-Path $scriptsDir) {
        $dest = Join-Path $ClaudeDir "scripts"
        New-Item -ItemType Directory -Force -Path $dest | Out-Null
        Get-ChildItem "$scriptsDir\*" -ErrorAction SilentlyContinue | ForEach-Object {
            Copy-Item $_.FullName $dest -Force
        }
    }

    Write-Ok "$PluginName ($category)"
    return $true
}

function Install-AllPlugins {
    Write-Info "Installing all plugins to $ClaudeDir ..."
    Write-Host ""

    # Create directories
    foreach ($dir in @("agents", "skills", "hooks", "commands", "scripts")) {
        New-Item -ItemType Directory -Force -Path (Join-Path $ClaudeDir $dir) | Out-Null
    }

    $count = 0
    $failed = 0

    Get-ChildItem $PluginsSource -Directory | ForEach-Object {
        if (Install-SinglePlugin $_.Name) {
            $count++
        } else {
            $failed++
        }
    }

    Write-Host ""
    Write-Host "============================================================" -ForegroundColor Blue
    Write-Ok "Installed $count plugins to $ClaudeDir"
    if ($failed -gt 0) { Write-Warn "Failed: $failed plugins" }
    Write-Host ""
    Write-Host "  Next steps:" -ForegroundColor White
    Write-Host "    1. Start a new Claude Code session: claude" -ForegroundColor Gray
    Write-Host "    2. Type /browse to see all available plugins" -ForegroundColor Gray
    Write-Host "    3. Try: 'run a security review on my code'" -ForegroundColor Gray
    Write-Host ""
}

function Show-PluginList {
    Write-Host ""
    Write-Host "Available Plugins (53):" -ForegroundColor White
    Write-Host ""

    foreach ($category in @("agents", "skills", "hooks", "commands")) {
        Write-Host "  ${category}:" -ForegroundColor Cyan
        Get-ChildItem $PluginsSource -Directory | ForEach-Object {
            $detected = Get-PluginCategory $_.FullName
            if ($detected -eq $category) {
                $desc = ""
                $manifest = Join-Path $_.FullName ".claude-plugin\plugin.json"
                if (Test-Path $manifest) {
                    try {
                        $json = Get-Content $manifest -Raw | ConvertFrom-Json
                        $desc = $json.description
                    } catch {}
                }
                if ($desc) {
                    Write-Host "    $($_.Name) -- $desc"
                } else {
                    Write-Host "    $($_.Name)"
                }
            }
        }
        Write-Host ""
    }
}

function Uninstall-AllPlugins {
    Write-Warn "This will remove all installed plugins from $ClaudeDir"
    $confirm = Read-Host "  Continue? (y/N)"

    if ($confirm -match '^[Yy]$') {
        foreach ($dir in @("agents", "skills", "hooks", "commands", "scripts")) {
            $path = Join-Path $ClaudeDir $dir
            if (Test-Path $path) { Remove-Item -Recurse -Force $path }
        }
        Write-Ok "All plugins removed from $ClaudeDir"
    } else {
        Write-Info "Cancelled"
    }
}

# Main
Write-Header

if ($Help) {
    Write-Host "Usage: .\install.ps1 [OPTIONS]"
    Write-Host ""
    Write-Host "Options:"
    Write-Host "  (no options)              Install all 53 plugins"
    Write-Host "  -List                     List available plugins"
    Write-Host "  -Plugin NAME              Install a single plugin"
    Write-Host "  -Uninstall                Remove all installed plugins"
    Write-Host "  -Help                     Show this help"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host "  .\install.ps1                          # install everything"
    Write-Host "  .\install.ps1 -Plugin architect        # install one plugin"
    Write-Host "  .\install.ps1 -List                    # see what's available"
} elseif ($List) {
    Show-PluginList
} elseif ($Uninstall) {
    Uninstall-AllPlugins
} elseif ($Plugin) {
    Install-SinglePlugin $Plugin
} else {
    Install-AllPlugins
}
