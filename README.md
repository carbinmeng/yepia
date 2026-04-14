# YEPIA (Your Exclusive Personal Intelligent Assistant)

YEPIA is an autonomous AI agent desktop app for macOS with integrated terminal, workspace tooling, and extensibility via:

- **MCP (Model Context Protocol)** servers for tools and resources
- **Subagents** for specialized agent roles
- **Skills** for reusable capability bundles
- **Bundled CLI Tools** for enhanced productivity

## Features

- 🤖 **Autonomous AI Agent** - Smart assistance with contextual awareness
- 🧠 **Brainstorm Multi-Agent** - Collaborative AI discussions with crew-based group chat
- 🖥️ **Integrated Terminal** - Full-featured terminal workspace
- 🔧 **Bundled Tools** - Pre-packaged CLI utilities (ripgrep, fd, jq, yq)
- 🔐 **Secure Key Storage** - API keys stored in macOS Keychain
- 🔌 **Extensible Architecture** - MCP servers, subagents, and skills
- 💬 **Enhanced Chat Interface** - Auto-expand bubbles, jump controls, running indicators

## Download

Get the latest macOS `.dmg` from this repo's **[GitHub Releases](../../releases)** page.

## System Requirements

- macOS 10.15+ (Catalina or later)
- Apple Silicon (M1/M2) recommended for optimal performance
- 4GB RAM minimum, 8GB recommended

## Install (macOS)

1. Open the downloaded `.dmg`.
2. Drag `YEPIA.app` into `/Applications`.
3. Launch `YEPIA` from Finder or Launchpad.

If macOS blocks the app, go to `System Settings` -> `Privacy & Security` and allow it to open.

> **⚠️ Important Note**: Since I do not have an Apple Developer account, macOS may block the app from opening. If you encounter this issue, please run the fix script located at [scripts/fix-yepia-macos.sh](scripts/fix-yepia-macos.sh) in the repository root.

## First Launch

On first launch after installation:

1. YEPIA asks you to select a work directory. This can be any folder on your disk. YEPIA uses it as the current working directory context for tools and file operations.
2. YEPIA may not have local provider/model definitions yet (`model_info.json`). It needs to download them from GitHub:
   - Source: https://github.com/carbinmeng/yepia_llm_providers
   - Downloaded file location: `~/.yepia/config/model_info.json`

YEPIA will show a startup toast when `model_info.json` is missing. Click the download action in that toast.
You can also open the `Settings` (gear icon) menu and choose `Update Provider & Models ...` to download it.

After the download finishes, restart YEPIA to start using the app normally.

Before you can create your first task and start chatting, you must:

1. Configure a provider API key in `Models` -> `Provider Auth` (`Add Auth`)
2. Pick at least one favorite model in `Models` -> `Online Models` (star icon)

Network requirement: your machine must be able to access GitHub. If the download fails or GitHub is unreachable, configure a proxy in `Settings` -> `Proxy Env` using shell-style env assignments, for example:

```sh
export https_proxy=http://127.0.0.1:123 http_proxy=http://127.0.0.1:123 all_proxy=socks5://127.0.0.1:456
```

When network requests fail, YEPIA will extract the `http_proxy=...` value from `Proxy Env` and use it as a fallback for retries. The AI agent will also use this proxy configuration automatically for network/download tasks it runs.

## Basic Usage

- `Models` (brain icon): configure API providers and models.
- `Terminal` (terminal icon): open the integrated terminal.
- `MCP Servers` (plug icon): add/edit MCP server integrations.
- `Settings` (gear icon): adjust app/backend settings.

## Subagents

YEPIA supports Subagents using the standard Claude Code-style definition: a Markdown file with YAML frontmatter plus a prompt body.

Minimum frontmatter:
- `name` (string)
- `description` (string)

Optional frontmatter:
- `tools` (array or comma-separated string)
- `model` (string)

Example:

```md
---
name: reviewer
description: Reviews changes and calls out risks.
tools: [read_file, search]
model: gpt-5.2
---

You are a strict reviewer. Focus on correctness and regressions.
```

Discovery paths (recursive):
- Work directory (current): `./.yepia/agents/`
- User-global: `~/.yepia/agents/` (overrides work directory on name conflicts)

## Skills

YEPIA supports Skills using the standard Claude Code-style definition: a `SKILL.md` file with YAML frontmatter plus a body.

Minimum frontmatter:
- `name` (string)
- `description` (string)

Example:

```md
---
name: root-cause-tracing
description: Trace errors backward to find the trigger.
---

When a bug occurs, reproduce it and trace from the failing symptom to the root cause.
```

Discovery paths (recursive, low to high priority):
- `~/.claude/skills/`
- `~/.agents/skills/`
- `~/.yepia/skills/`
- Work directory (current): `./.claude/skills/`
- Work directory (current): `./.agents/skills/`
- Work directory (current): `./.yepia/skills/` (highest priority)

### Configure API Provider (Required)

1. Open `Models`.
2. In `Provider Auth`, click `Add Auth` (plus icon).
3. Select a provider and paste your API key.
4. Save.

🔐 **Security**: API keys are securely stored in macOS Keychain, providing hardware-backed encryption and protection. Your keys are never stored in plain text files and are protected by macOS security mechanisms.

### Choose Favorite Model (Required)

1. Open `Models`.
2. In `Online Models`, find a model you want to use.
3. Click the star icon to add it to your favorites.

After configuring a provider API key and selecting at least one favorite model, you can create tasks and start chatting.

### Bundled CLI Tools

YEPIA includes essential CLI tools pre-packaged for macOS Apple Silicon, ensuring consistent performance and eliminating manual setup:

### 📦 **ripgrep (rg)** - Fast File Search

**GitHub**: [BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep)

Blazingly fast command-line search tool that combines the usability of `grep` with the speed of `ag`. Perfect for searching through large codebases.

```bash
rg "pattern" --type rust --case-sensitive
```

### 📂 **fd** - User-Friendly File Finder

**GitHub**: [sharkdp/fd](https://github.com/sharkdp/fd)

Simple, fast, and user-friendly alternative to `find`. Features intuitive syntax, colorized output, and smart defaults.

```bash
fd "pattern" --extension md --type file
```

### 🔧 **jq** - JSON Processor

**GitHub**: [jqlang/jq](https://github.com/jqlang/jq)

Lightweight and flexible command-line JSON processor. Essential for parsing, filtering, and transforming JSON data.

```bash
echo '{"name": "test"}' | jq '.name'
```

### 📋 **yq** - YAML/XML/JSON Processor

**GitHub**: [mikefarah/yq](https://github.com/mikefarah/yq)

Portable command-line processor for YAML, XML, and JSON files. Like `jq` but supports multiple formats and is perfect for configuration file management.

```bash
yq '.database.host' config.yaml
```

### 🚀 Benefits

- **Zero Setup**: Tools are immediately available without installation
- **Consistent Versions**: Tested versions ensure compatibility
- **Optimized for Apple Silicon**: Native ARM64 performance
- **Integrated**: Seamlessly works with YEPIA's tool system

### 🛠️ Troubleshooting

If bundled tools exit with code 137 (SIGKILL), they may have macOS quarantine attributes:

```bash
# Remove quarantine attributes
xattr -d com.apple.quarantine /Applications/YEPIA.app/Contents/Resources/bin/rg
xattr -d com.apple.quarantine /Applications/YEPIA.app/Contents/Resources/bin/fd
xattr -d com.apple.quarantine /Applications/YEPIA.app/Contents/Resources/bin/jq
xattr -d com.apple.quarantine /Applications/YEPIA.app/Contents/Resources/bin/yq
```

## Add MCP Servers (Optional)

1. Open `MCP Servers`.
2. Click the `+` icon in the header to open `Add MCP Server`.
3. Paste an MCP JSON config (example is shown in the editor) and save.

To edit the MCP config file directly:
- Open `MCP Servers` and click the pencil icon in the header (`Edit MCP Configuration File`).

Note: MCP config changes take effect after saving and restarting MCP connections (as shown in the editor).

## Troubleshooting

- Logs: `~/.yepia/cache/logs/*.log`

### Terminal Does Not Start (macOS)

If the integrated terminal fails to spawn on macOS, a known cause is the `node-pty` helper losing its executable bit inside the installed app.

Workaround (requires admin):

```bash
sudo chmod +x /Applications/YEPIA.app/Contents/Resources/app.asar.unpacked/node_modules/node-pty/prebuilds/darwin-arm64/spawn-helper
```

## Uninstall

1. Remove `YEPIA.app` from `/Applications`.
2. Optional: delete YEPIA data at `~/.yepia/` (this removes cached data, logs, and saved settings).

Your projects/files remain in the work directory you selected.

## Screenshots

![](screenshot/iScreen%20Shoter%20-%20YEPIA%20-%20260324153059.png)
![](screenshot/iScreen%20Shoter%20-%20YEPIA%20-%20260324153114.png)
![](screenshot/iScreen%20Shoter%20-%20YEPIA%20-%20260324153141.png)
![](screenshot/iScreen%20Shoter%20-%20YEPIA%20-%20260324154142.png)
![](screenshot/iScreen%20Shoter%20-%20YEPIA%20-%20260324155644.png)