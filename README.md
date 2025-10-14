# Dotfiles

> My personal macOS development environment, managed with [chezmoi](https://www.chezmoi.io/)

A curated collection of configurations for a modern, efficient, and aesthetically pleasing development setup. Features
unified the Catppuccin theming across all tools, automated package management, and XDG Base Directory compliance.

## Features

- **Unified Theming**: Catppuccin color schemes across all tools (Frappe, Latte, Macchiato, Mocha)
- **Automated Setup**: One-command installation of all tools and configurations
- **Package Management**: Declarative package installation via Homebrew (brews, casks, Mac App Store)
- **Modern Shell**: ZSH with oh-my-zsh, syntax highlighting, and smart completions
- **Developer Tools**: Pre-configured Neovim, Git, Docker, Kubernetes, AWS, and more
- **Smart Navigation**: fzf, zoxide, and custom aliases for rapid workflow
- **XDG Compliant**: Follows XDG Base Directory specification for clean home directory

## Included Configurations

| Tool                                                          | Purpose                                         |
|---------------------------------------------------------------|-------------------------------------------------|
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

## Quick Start

### Fresh Installation

```bash
# Install chezmoi and apply dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply ararat-poghosyan

# Or if you prefer to review changes first
chezmoi init ararat-poghosyan
chezmoi diff
chezmoi apply
```

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

### Setting Your Theme

The dotfiles support four Catppuccin variants. Change the theme by editing
`~/.local/share/chezmoi/home/.chezmoi.toml.tmpl`:

```toml
[data]
# Choose one: "frappe", "latte", "macchiato", "mocha"
theme = "frappe"
```

After changing the theme, reapply with the `--init` flag to regenerate the config:

```bash
chezmoi apply --init
```

> **Note**: The `--init` flag is required when modifying `.chezmoi.toml.tmpl` to ensure template variables are re-evaluated.

**Available Themes:**

- `frappe` - Warm, cozy dark theme (default)
- `latte` - Light theme for daytime coding
- `macchiato` - Darker, more vibrant variant
- `mocha` - Deepest dark theme with high contrast

### Personal Information

Update your personal details in the same file:

```toml
[data]
theme = "frappe"
name = "Your Name"
fullName = "Your Full Name"
email = "your.email@example.com"
```

These values are used for git configuration and other personalized settings.

## What Gets Installed

### CLI Tools (Homebrew)

Development tools, languages, and utilities including:

- **Languages**: Node.js, Go, PHP, Rust
- **DevOps**: Docker, Kubernetes (kubectl, helm), Terraform, Ansible
- **AWS**: AWS CLI, SAM CLI, AWS Shell
- **Database**: MySQL Client, MongoDB Compass, Trino
- **Media**: FFmpeg, ImageMagick, ExifTool
- **Productivity**: bat, fzf, ripgrep, tree, jq

### GUI Applications (Casks)

Essential macOS applications:

- **Development**: Visual Studio Code, JetBrains Toolbox, Docker Desktop
- **Productivity**: Raycast, Notion, 1Password
- **Communication**: Slack, Discord, Telegram, Zoom
- **Browsers**: Google Chrome, Firefox
- **Media**: Spotify, VLC
- **Utilities**: AppCleaner, Cyberduck, Tower (Git client)

### Runtime Versions (mise)

Automatically managed via mise:

- Node.js 24.9
- Go (latest)
- Rust (latest)
- .NET 8.0 & 9.0
- Global NPM packages: AWS CDK, Claude Code

## Directory Structure

```text
~/.local/share/chezmoi/
├── home/                           # Files to be installed in $HOME
│   ├── .chezmoi.toml.tmpl         # Main configuration (theme, personal info)
│   ├── .chezmoidata/              # Data files
│   │   └── packages.yaml          # Package definitions
│   ├── .chezmoiexternal.toml      # External dependencies
│   ├── .chezmoiscripts/           # Automated scripts
│   │   ├── run_before_*           # Pre-installation scripts
│   │   └── run_onchange_*         # Scripts that run on file changes
│   ├── dot_*.zsh                  # Shell configuration
│   ├── dot_gitconfig.tmpl         # Git configuration
│   └── private_dot_config/        # Application configs
│       ├── private_bat/           # Bat themes and config
│       ├── private_btop/          # Btop resource monitor config and themes
│       ├── private_fzf/           # FZF themes
│       ├── private_ghostty/       # Ghostty terminal config
│       ├── private_lazygit/       # Lazygit config and themes
│       ├── private_mise/          # Mise runtime versions
│       ├── private_nvim/          # Neovim configuration
│       └── private_yazi/          # Yazi file manager config
└── README.md
```

## Key Features Explained

### Automated Package Installation

On the first run, scripts automatically:

1. Install Homebrew (if not present)
2. Install all brew packages, casks, and Mac App Store apps
3. Set up oh-my-zsh with plugins
4. Install programming language runtimes via mise
5. Build theme caches (bat)

### Smart Shell Aliases

```bash
# Quick navigation
p          # cd $HOME/Projects
ws         # cd $HOME/Projects/Wirestock
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

### Adding Shell Aliases

Edit `home/dot_aliases.zsh` and run `chezmoi apply`.

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
chezmoi edit ~/.zshrc        # Opens in $EDITOR
chezmoi edit --apply ~/.zshrc  # Apply after saving
```

### Remove Files

If you no longer want chezmoi to manage a file:

```bash
chezmoi forget ~/.someconfig
```

## Troubleshooting

### The Theme Was Not Applied

1. Verify theme name in `.chezmoi.toml.tmpl` is one of: `frappe`, `latte`, `macchiato`, `mocha`
2. Reapply configuration: `chezmoi apply -v`
3. Rebuild bat cache: `bat cache --build`
4. Restart your shell: `exec zsh`

### Packages Not Installing

```bash
# Re-run installation script manually
bash ~/.local/share/chezmoi/home/.chezmoiscripts/run_onchange_darwin-install-packages.sh.tmpl
```

### Shell Completions Missing

```bash
# Reload shell configuration
source ~/.zshrc
```

## License

Personal dotfiles - feel free to use as inspiration or fork for your own setup!

## Acknowledgments

- [Catppuccin](https://catppuccin.com/) - Soothing pastel theme
- [chezmoi](https://www.chezmoi.io/) - Dotfile management
- [LazyVim](https://www.lazyvim.org/) - Neovim distribution
- [oh-my-zsh](https://ohmyz.sh/) - ZSH framework

---

🚀 Happy hacking!

