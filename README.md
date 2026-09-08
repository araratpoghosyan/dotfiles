# Dotfiles

> My personal macOS development environment, managed with [chezmoi](https://www.chezmoi.io/)

A curated collection of configurations for a modern, efficient, and aesthetically pleasing development setup. Features
unified theming across all tools with multiple theme families, automated package management, and XDG Base Directory compliance.

![screenshot.jpeg](docs/screenshot.jpeg)

## Features

- **Unified Theming**: Multiple theme options across all tools (Catppuccin, TokyoNight, Nord, Dracula, 0x96f)
- **Automated Setup**: One-command installation of all tools and configurations
- **Package Management**: Declarative package installation via Homebrew (brews, casks, Mac App Store)
- **Modern Shell**: ZSH with oh-my-zsh, syntax highlighting, and smart completions
- **Developer Tools**: Pre-configured Neovim, Git, Docker, Kubernetes, AWS, and more
- **Smart Navigation**: fzf, zoxide, and custom aliases for rapid workflow
- **XDG Compliant**: Follows XDG Base Directory specification for clean home directory

## Included Configurations

| Tool                                                          | Purpose                                         |
| ------------------------------------------------------------- | ----------------------------------------------- |
| **[bat](https://github.com/sharkdp/bat)**                     | Cat replacement with syntax highlighting        |
| **[btop](https://github.com/aristocratos/btop)**              | Resource monitor with intuitive interface       |
| **[fzf](https://github.com/junegunn/fzf)**                    | Fuzzy finder for files and history              |
| **[ghostty](https://ghostty.org/)**                           | Fast, feature-rich GPU-accelerated terminal     |
| **[lazygit](https://github.com/jesseduffield/lazygit)**       | Terminal UI for git commands                    |
| **[lazydocker](https://github.com/jesseduffield/lazydocker)** | Terminal UI for docker management               |
| **[mise](https://mise.jdx.dev/)**                             | Polyglot runtime manager (Node, Go, Rust, .NET) |
| **[neovim](https://neovim.io/)**                              | Hyperextensible text editor (LazyVim-based)     |
| **[yazi](https://github.com/sxyazi/yazi)**                    | Blazing fast terminal file manager              |
| **[zoxide](https://github.com/ajeetdsouza/zoxide)**           | Smarter cd command with directory jumping       |

## Prerequisites

- macOS (Apple Silicon or Intel)
- Command Line Tools: `xcode-select --install`
- Homebrew (see installation below)
- 1Password and 1Password CLI, signed in (see installation below — required during the first
  apply because the SSH config is pulled from 1Password)
- Signed in to the Mac App Store (for MAS apps; the `mas` CLI itself installs automatically)

### Manual Installation Steps

These tools must be installed **before** running chezmoi for the first time:

#### 1. Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Put Homebrew on PATH for the current session (Apple Silicon; use /usr/local/bin/brew on Intel)
eval "$(/opt/homebrew/bin/brew shellenv)"
```

No need to edit `~/.zprofile`: chezmoi manages `~/.config/zsh/.zprofile`, which loads Homebrew
for every future login shell.

#### 2. Install 1Password

Download and install from [1password.com](https://1password.com/downloads/mac/):

```bash
# Or use Homebrew
brew install --cask 1password
```

**Important:** Launch 1Password and sign in to your account before proceeding.

#### 3. Install and Configure 1Password CLI

```bash
# Install 1Password CLI
brew install --cask 1password-cli

# Verify installation
op --version

# Add your 1Password account
op account add --address <your-subdomain>.1password.com --email <your-email>

# Sign in (if not using biometric unlock)
eval $(op signin --account <your-subdomain>)

# Enable biometric unlock for seamless integration
# Go to 1Password app → Settings → Developer →
# Enable "Connect with 1Password CLI" and "Use biometric unlock"
```

With biometric unlock enabled, chezmoi can access 1Password secrets without manual authentication.

#### 4. Sign in to the Mac App Store

The `mas` CLI (used for Mac App Store apps) is installed automatically from `packages.yaml`,
but it can only install apps while you are signed in to the App Store app.
If you skip this, MAS apps are skipped on the first apply and installed on a later one.

## Quick Start

### Fresh Installation

```bash
# Install chezmoi, clone the dotfiles, and generate your config
sh -c "$(curl -fsLS get.chezmoi.io)" -- init ararat-poghosyan
```

On first run chezmoi prompts for your theme (pick from a list), name, email, and 1Password
account, and writes the answers to `~/.config/chezmoi/chezmoi.toml`. Then preview and apply:

```bash
chezmoi diff
chezmoi apply
```

Or do everything in one step with `chezmoi init --apply ararat-poghosyan`.

### Existing Installation

```bash
# Update to latest configuration
chezmoi update

# Or manually
cd ~/.local/share/chezmoi
git pull
chezmoi apply
```

## Configuration

### Initial Setup

Your personal settings live in `~/.config/chezmoi/chezmoi.toml`. The file is generated by
`chezmoi init` from `home/.chezmoi.toml.tmpl`, which prompts once for each value:

- Your chosen theme (chosen from the list in `home/.chezmoidata/themes.yaml`)
- Personal information (name, full name, email)
- 1Password account

To change a value later, edit `~/.config/chezmoi/chezmoi.toml` directly and run `chezmoi apply`.
Re-running `chezmoi init` only asks for keys that are missing from the existing config.

### Setting Your Theme

The dotfiles support multiple theme families with variants. Themes are centrally managed in `home/.chezmoidata/themes.yaml` and automatically validated before applying.

Change the theme by editing `~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
theme = "catppuccin-mocha"
```

Then reapply:

```bash
chezmoi apply
```

Alternatively, delete the `theme` line and run `chezmoi init --apply` to pick from the list again.

> **Note**: An unknown theme name, or a theme missing an asset for any tool, aborts `chezmoi apply`
> before anything is written, with a message listing what is wrong.

**Available Themes:**

- **Catppuccin** (4 variants)
  - `catppuccin-frappe` - Warm, cozy pastel theme
  - `catppuccin-latte` - Light mode variant
  - `catppuccin-macchiato` - Medium contrast pastel theme
  - `catppuccin-mocha` - Dark, rich pastel theme
- **TokyoNight** (4 variants)
  - `tokyonight-day` - Clean light theme
  - `tokyonight-moon` - Dark theme with purple accent
  - `tokyonight-night` - Deep dark theme
  - `tokyonight-storm` - Storm-inspired dark theme
- **Nord** (1 variant)
  - `nord` - Arctic, north-bluish color palette
- **Dracula** (1 variant)
  - `dracula` - Dark theme with vibrant colors
- **0x96f** (1 variant)
  - `0x96f` - Custom minimalist dark theme

**Theme Coverage:**

All 11 themes are available for every themed tool: bat, btop, eza, fzf, ghostty, lazygit, neovim, opencode, yazi, and zellij.
Only the active theme's files are deployed to `~/.config`; the other themes stay in the source tree
(`home/.chezmoiignore` hides them). Switching themes deploys the new theme and removes the previous one's files. The light themes (`catppuccin-latte`, `tokyonight-day`) also switch delta/lazygit to light mode and keep macOS in light appearance (via the `light` flag in `themes.yaml`).

**Theme Management:**

Themes are defined in `home/.chezmoidata/themes.yaml` with the following structure:

```yaml
themes:
  catppuccin-mocha:
    light: false
    description: Dark, rich pastel theme
    family: catppuccin
    bat: catppuccin-mocha
    ghostty: Catppuccin Mocha
    nvim:
      repo: catppuccin/nvim
      module: catppuccin
      opts: { flavour: mocha }
```

This centralized approach eliminates if/else chains in configuration files and makes adding new themes straightforward.

### Personal Information

Update your personal details in `~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
# Theme for all the tools that support it
theme = "catppuccin-macchiato"

# Personal information
name = "Your Name"
fullName = "Your Full Name"
email = "your.email@example.com"

# Your 1Password account
onePasswordAccount = "your.email@example.com"
```

These values are used for git configuration and other personalized settings.

### 1Password Integration

This dotfiles repository leverages 1Password CLI for secure secrets management. With 1Password integration, you can:

- Store sensitive data (API keys, tokens, credentials) securely in 1Password
- Reference secrets in your dotfiles using chezmoi templates
- Avoid committing secrets to version control

#### Using 1Password in Templates

chezmoi provides several template functions to access 1Password data:

**onepasswordRead** - Direct secret retrieval using secret references:
```tmpl
{{ onepasswordRead "op://Private/GitHub/personal-access-token" }}
```

**onepassword** - Retrieve full item details as JSON:
```tmpl
{{ (onepassword "your-item-uuid").fields.password.value }}
```

**onepasswordDetailsFields** - Simplified field access:
```tmpl
{{ (onepasswordDetailsFields "your-item-uuid").password.value }}
```

#### Example Usage

In any `.tmpl` file in your dotfiles:

```toml
# ~/.config/app/config.toml.tmpl
api_key = "{{ onepasswordRead "op://Private/MyApp/api-key" }}"
```

```yaml
# ~/.config/service/credentials.yaml.tmpl
token: {{ onepasswordRead "op://Work/ServiceToken/credential" }}
```

#### Configuration

To disable interactive prompts (useful for automated workflows), add to `~/.config/chezmoi/chezmoi.toml`:

```toml
[onepassword]
prompt = false
```

⚠️ **Warning:** Only use `prompt = false` on trusted, personal machines. This allows chezmoi to access secrets without confirmation.

#### Best Practices

1. **Use secret references**: Prefer `op://vault/item/field` format for clarity
2. **Enable biometric unlock**: Eliminates manual authentication during `chezmoi apply`
3. **Organize vaults**: Use separate vaults (Private, Work, etc.) for different contexts
4. **Document secret locations**: Add comments in templates indicating which 1Password item is referenced

## What Gets Installed

### CLI Tools (Homebrew)

Development tools, languages, and utilities including:

- **Languages**: PHP (Node.js, Go, and Rust are managed by mise — see below)
- **DevOps**: Docker, Kubernetes (kubectl, helm, helmfile), Ansible
- **AWS**: AWS CLI, SAM CLI
- **Database**: MySQL Client, MongoDB Compass, Trino
- **Media**: FFmpeg, ImageMagick, ExifTool
- **Productivity**: bat, fzf, ripgrep, tree, jq

### GUI Applications (Casks)

Essential macOS applications:

- **Development**: Visual Studio Code, JetBrains Toolbox, Docker Desktop
- **Productivity**: Raycast, Notion
- **Communication**: Slack, Discord, Telegram, Zoom
- **Browsers**: Google Chrome, Firefox
- **Media**: Spotify, VLC
- **Utilities**: AppCleaner, Cyberduck, Tower (Git client)

> **Note**: The 1Password casks are declared in `packages.yaml` for completeness, but 1Password
> and its CLI must be installed and signed in manually **before** the first apply (see Prerequisites)

### Runtime Versions (mise)

Automatically managed via mise (the single owner of language runtimes — brew does not install Node/Go/Rust):

- Node.js 24.9
- Go (latest)
- Rust (latest)
- .NET 8.0 & 9.0
- Lua 5.1 (for Neovim)
- Global NPM packages: bun, AWS CDK, Prettier, Mermaid CLI

> **Note**: Claude Code is installed separately via its official install script (`run_once_install-claude-code`).

## Directory Structure

```text
~/.local/share/chezmoi/
├── home/                          # Files to be installed in $HOME (chezmoi root)
│   ├── .chezmoi.toml.tmpl         # Config template; prompts once and writes ~/.config/chezmoi/chezmoi.toml
│   ├── .chezmoidata/              # Data files
│   │   ├── packages.yaml          # Package definitions
│   │   ├── theme-assets.yaml      # Where each tool keeps its per-theme asset
│   │   └── themes.yaml            # Theme registry (light flag, bat/ghostty names, nvim spec)
│   ├── .chezmoiexternal.toml      # External dependencies
│   ├── .chezmoiscripts/           # Automated scripts
│   │   ├── run_before_*           # Pre-apply assertions (theme registry coverage)
│   │   └── run_onchange_*         # Scripts that run on file changes (bat cache, mise, prune inactive themes, macOS defaults)
│   ├── .chezmoitemplates/themes/  # eza, fzf and lazygit theme inputs, merged into their configs at render time
│   ├── .chezmoiignore             # Hides every theme except the active one
│   ├── .chezmoiremove             # Old targets to delete on apply
│   ├── dot_zshenv                 # Environment only; sets ZDOTDIR and FZF_DEFAULT_OPTS_FILE
│   ├── dot_gitconfig.tmpl         # Git configuration
│   ├── dot_claude/                # Claude Code settings and statusline
│   ├── private_dot_ssh/           # SSH config (content pulled from 1Password)
│   └── private_dot_config/        # Application configs
│       ├── private_bat/           # Bat config and themes (active one deployed)
│       ├── private_btop/          # Btop resource monitor config and themes (active one deployed)
│       ├── private_eza/           # Eza theme.yml, rendered from the active theme
│       ├── private_fzf/           # fzfrc, rendered from the active theme
│       ├── private_ghostty/       # Ghostty terminal config
│       ├── private_lazygit/       # Lazygit config, theme merged in at render time
│       ├── private_mise/          # Mise runtime versions
│       ├── private_nvim/          # Neovim configuration
│       ├── private_opencode/      # OpenCode config and themes (active one deployed)
│       ├── private_yazi/          # Yazi file manager config and flavors (active one deployed)
│       ├── private_zsh/           # ZDOTDIR: .zprofile, .zshrc, conf.d/ fragments
│       └── private_zellij/        # Zellij config, layouts, and themes (active one deployed)
└── README.md
```

## Key Features Explained

### Automated Package Installation

After prerequisites are met, scripts automatically:

1. Install all brew packages, casks, and Mac App Store apps from `packages.yaml`
2. Install oh-my-zsh and its plugins (as chezmoi externals)
3. Install programming language runtimes via mise
4. Build theme caches (bat)

**Prerequisites** (must be installed manually):
- Homebrew
- 1Password and 1Password CLI (signed in)

### Theme Validation

`home/.chezmoiscripts/run_before_assert-theme-coverage.sh.tmpl` is a template-only assertion.
It renders to nothing on success (so no script runs), and on failure it aborts `chezmoi apply`
before any file is written. It checks three things on every apply:

- The selected theme exists in `themes.yaml`
- Every theme in `themes.yaml` has an asset for every themed tool (bat, btop, eza, fzf, lazygit,
  opencode, yazi, zellij) and the `ghostty` and `nvim` registry fields
- No tool directory contains a theme asset for a theme that is not in `themes.yaml`

Example error output:
```
chezmoi: template: ... error calling fail: theme registry has themes without assets (theme / tool / expected path)

  - my-new-theme           bat       private_dot_config/private_bat/themes/my-new-theme.tmTheme
  - my-new-theme           zellij    private_dot_config/private_zellij/themes/my-new-theme.kdl
```

The per-tool asset locations live in `home/.chezmoidata/theme-assets.yaml`, shared with `.chezmoiignore`
and the prune script. When a new themed tool is added, add its entry there.

### Smart Shell Aliases

```bash
# Quick navigation
p          # cd $HOME/Projects
cd         # zoxide-powered smart directory jumping

# Enhanced tools
cat        # Actually runs 'bat' with syntax highlighting
vim        # Runs neovim
y          # Opens yazi file manager
uuid       # Generate lowercase UUID
```

### Environment Variables

All configurations respect the XDG Base Directory specification:

- `$XDG_CONFIG_HOME` - Used for all config directories
- `$ZDOTDIR` - `~/.config/zsh`; zsh reads `.zprofile`, `.zshrc` and `conf.d/` from there, so only
  `~/.zshenv` remains in the home directory
- `$FZF_DEFAULT_OPTS_FILE` - `~/.config/fzf/fzfrc`, rendered for the active theme
- `$HOME` - Explicit references for non-XDG paths
- No hardcoded paths or tilde expansion

## Customization

### Adding Packages

Edit `home/.chezmoidata/packages.yaml`:

```yaml
packages:
  darwin:
    brews:
      - "your-package-name"
    casks:
      - "your-app-name"
    mas:
      - name: "App Name"
        id: 1234567890  # App Store ID
```

Then run:

```bash
chezmoi apply
```

To find Mac App Store app IDs:

```bash
mas search "App Name"
```

### Adding Themes

To add a custom theme, edit `home/.chezmoidata/themes.yaml`:

```yaml
themes:
  your-theme-name:
    light: false
    description: Your theme description
    family: your-theme-family
    bat: Name inside your-theme-name.tmTheme
    ghostty: Ghostty Theme Name
    nvim:
      repo: owner/your-theme.nvim
      module: your-theme        # omit if the plugin needs no setup()
      opts: { style: variant }  # omit for setup() with no arguments
```

The theme structure includes:
- key: The canonical theme identifier used in `~/.config/chezmoi/chezmoi.toml`
- `light`: Whether the theme is a light theme (drives delta, lazygit, and macOS appearance)
- `description`: Brief description shown in the theme picker and in assertion errors
- `family`: Theme family for grouping
- `bat`: Theme name as written inside the `.tmTheme` file (bat selects by that name, not by file name)
- `ghostty`: Theme name as Ghostty spells it
- `nvim`: lazy.nvim spec for the colorscheme plugin (`repo`, optional `module`, `opts`, `lazy`);
  the Neovim colorscheme file is rendered from this, no per-theme Lua file is needed

After adding a theme:

1. Add the theme's asset for every tool listed in `home/.chezmoidata/theme-assets.yaml` (that file
   says where each one lives)
2. Run `chezmoi apply` to regenerate configurations
3. The theme picker picks up the new theme automatically, and the coverage assertion fails
   `chezmoi apply` until every tool has its asset

### Adding Shell Aliases

Edit `home/private_dot_config/private_zsh/conf.d/30-aliases.zsh` and run `chezmoi apply`.
Tool initialization lives in `20-tools.zsh`, PATH entries in `10-path.zsh`.

### Modifying Tool Configs

All tool configurations are in `home/private_dot_config/`. After editing, run:

```bash
chezmoi apply
```

## Tips & Tricks

### Preview Changes

Always preview before applying:

```bash
chezmoi diff
```

### Update Dotfiles

Pull the latest changes and apply:

```bash
chezmoi update -v  # Verbose output
```

### Edit Configuration

Use chezmoi's built-in editor:

```bash
chezmoi edit ~/.config/zsh/.zshrc          # Opens in $EDITOR
chezmoi edit --apply ~/.config/zsh/.zshrc  # Apply after saving
```

### Remove Files

If you no longer want chezmoi to manage a file:

```bash
chezmoi forget ~/.someconfig
```

## Troubleshooting

### The Theme Was Not Applied

1. Verify the theme name in `~/.config/chezmoi/chezmoi.toml` matches one of the available themes (see Configuration section)
2. Reapply configuration: `chezmoi apply -v`
3. Rebuild bat cache: `bat cache --build`
4. Restart your shell: `exec zsh`

### Packages Not Installing

```bash
# The package script runs on every apply; re-run with verbose output
chezmoi apply -v

# If a script is stuck in a bad recorded state, clear chezmoi's script state and re-apply
chezmoi state delete-bucket --bucket=scriptState
chezmoi apply
```

### Shell Completions Missing

```bash
# Start a fresh shell
exec zsh
```

### 1Password CLI Not Working

If chezmoi cannot access 1Password secrets:

```bash
# Verify 1Password CLI is installed
op --version

# Check if you're signed in
op account list

# Sign in if needed
eval $(op signin --account <your-subdomain>)

# Enable biometric unlock in 1Password app
# Settings → Developer → Enable "Connect with 1Password CLI"

# Test access
op read "op://Private/test-item/password"
```

If you see `prompt = false` errors, ensure biometric unlock is enabled or remove that setting from `~/.config/chezmoi/chezmoi.toml`.

## License

Personal dotfiles - feel free to use as inspiration or fork for your own setup!

## Acknowledgments

- [Catppuccin](https://catppuccin.com/) - Soothing pastel theme
- [chezmoi](https://www.chezmoi.io/) - Dotfile management
- [LazyVim](https://www.lazyvim.org/) - Neovim distribution
- [oh-my-zsh](https://ohmyz.sh/) - ZSH framework

---

🚀 Happy hacking!
