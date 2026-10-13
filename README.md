# Dotfiles

> My macOS development environment, managed with [chezmoi](https://www.chezmoi.io/).
>
> This is my personal setup, published for reference. I don't take contributions or feature
> requests; fork it if you want to change it.

[![CI](https://github.com/araratpoghosyan/dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/araratpoghosyan/dotfiles/actions/workflows/ci.yml)

One theme across every terminal tool, one declarative package list, an XDG-clean home directory,
and a set of guards (template-time assertions, CI, daily drift detection) that keep the machine and
the repository from quietly diverging.

## Highlights

- **One theme, nineteen choices.** Pick from Catppuccin, TokyoNight, ayu, Kanagawa, Atom One, Nord,
  Dracula or 0x96f once;
  bat, btop, eza, fzf, ghostty, herdr, lazygit, neovim, opencode, yazi, delta and the macOS
  appearance all follow. Only the active theme's files are deployed.
- **Declarative packages.** `packages.yaml` renders a Brewfile (3 taps, 62 formulae, 31 casks,
  1 App Store app) that `brew bundle` applies on every `chezmoi apply`. Language runtimes come
  from mise.
- **XDG-native shell.** A two-line `~/.zshenv` hands over to `~/.config/zsh`, where the
  environment, login PATH, oh-my-zsh setup and small single-purpose fragments live.
- **Guard rails.** A template-time assertion refuses to apply a broken theme registry, CI renders
  the whole tree for every theme on each push, and a daily LaunchAgent reports drift between the
  machine and the source.

## What's inside

| Tool | Configured as |
| --- | --- |
| [bat](https://github.com/sharkdp/bat) | Themed `cat` replacement, plain style, no paging |
| [btop](https://github.com/aristocratos/btop) | Resource monitor, themed |
| [eza](https://github.com/eza-community/eza) | `ls` replacement with icons, themed; aliases `ls`, `ll`, `la`, `lt` |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder with eza/bat previews, colors from a themed options file |
| [ghostty](https://ghostty.org/) | Terminal, JetBrains Mono Nerd Font, themed |
| [git](https://git-scm.com/) + [delta](https://github.com/dandavison/delta) | Side-by-side diffs; light or dark follows the theme |
| [herdr](https://herdr.dev/) | Agent session manager, themed; every theme shades the sidebar and tab bar, palettes herdr lacks are built from its custom color tokens, 0x96f follows the terminal palette. Ghostty notifications for background agents |
| [lazygit](https://github.com/jesseduffield/lazygit) | Git TUI with delta paging, theme merged into its config |
| [mise](https://mise.jdx.dev/) | Node 24.21, Go, Rust, .NET 8 and 9, Lua 5.1, and global npm tools |
| [neovim](https://neovim.io/) | [LazyVim](https://www.lazyvim.org/) with language extras; colorscheme rendered from the theme registry |
| [opencode](https://opencode.ai/) | AI coding agent, themed |
| [yazi](https://github.com/sxyazi/yazi) | Terminal file manager, themed flavor |
| zsh | [oh-my-zsh](https://ohmyz.sh/) (git, docker, helm, kubectl, syntax highlighting), [zoxide](https://github.com/ajeetdsouza/zoxide) as `cd` |

Everything else in `packages.yaml` (Docker Desktop, JetBrains Toolbox, kubectl tooling, AWS CLI,
browsers, chat apps, fonts, and so on) is installed but not configured by this repository.

## Requirements

- macOS on Apple Silicon or Intel. The repository is macOS-only by design.
- Preferably a fresh user account. If you bring files over with Migration Assistant, leave out
  `~/.config`, `~/.zshenv`, `~/.oh-my-zsh` and `/Applications`: migrated copies of managed files
  make the first apply ask about every one of them, and pre-installed apps make their casks fail.
- Signed in to iCloud and, if you want the App Store apps, to the App Store, before you start.
- Command Line Tools: `xcode-select --install`
- [Homebrew](https://brew.sh/). Install it, then put it on `PATH` for the current session:

  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"   # /usr/local/bin/brew on Intel
  ```

  Ignore the installer's closing "Next steps" about `~/.zprofile`. chezmoi manages
  `~/.config/zsh/.zprofile`, which loads Homebrew for every future login shell, and once `ZDOTDIR`
  is set zsh never reads `~/.zprofile` again. If you already pasted those lines, they do no harm.
- Optional: the App Store sign-in above. Without it, App Store entries are skipped with a warning
  until you sign in and apply again.

## Install

```bash
brew install chezmoi
chezmoi init --apply araratpoghosyan
```

Homebrew is already required, so it installs chezmoi too, and `brew upgrade` keeps it current
along with everything else. `chezmoi init` clones this repository to `~/.local/share/chezmoi`,
prompts once for your theme (from a list), name and email, writes the answers to
`~/.config/chezmoi/chezmoi.toml`, and applies. To review before applying, drop `--apply` and run
`chezmoi diff` first.

The first apply:

1. Checks the theme registry and aborts with a precise message if anything is missing.
2. Renders every managed file, including the Brewfile, and clones oh-my-zsh.
3. Runs `brew bundle` against the rendered Brewfile, installs Claude Code, runs `mise install`,
   rebuilds the bat theme cache, applies macOS defaults, and loads the drift-check LaunchAgent.

Expect the first apply to take 30 to 90 minutes, most of it Homebrew downloading casks and mise
downloading runtimes, and stay near the keyboard: some cask installers ask for your password, the
drift check's first run makes macOS ask whether it may send notifications (allow it), and the
defaults script restarts the Dock and Finder near the end. Should Homebrew stop on a package, see
Troubleshooting; a second
`chezmoi apply` picks up where it left off.

Open a new terminal when it finishes.

## Everyday use

| Task | Command |
| --- | --- |
| Pull and apply the latest repository state | `chezmoi update` |
| Preview what an apply would change | `chezmoi diff` |
| Edit a managed file in place and apply | `chezmoi edit --apply ~/.config/zsh/.zshrc` |
| Change the theme | `theme` (fzf picker) or `theme <name>`; `theme <Tab>` completes the names |
| Change a personal value | edit `~/.config/chezmoi/chezmoi.toml`, then `chezmoi apply` |
| Anything declared but not installed? | `brew bundle check` |
| Anything installed but not declared? | `brew bundle cleanup --dry-run` |
| Is the machine drifting from the repo? | `chezmoi-drift-check` (exit 1 means yes; see below) |
| Stop managing a file | `chezmoi forget <path>` |

## Theming

### The registry

`home/.chezmoidata/themes.yaml` is the single description of every theme:

```yaml
themes:
  catppuccin-mocha:
    light: false                   # drives delta, lazygit and macOS appearance
    description: Dark, rich pastel theme
    ghostty: Catppuccin Mocha      # name as ghostty spells it
    nvim:                          # lazy.nvim spec; the colorscheme file is rendered from this
      repo: catppuccin/nvim
      module: catppuccin
      opts: { flavour: mocha }
      # colorscheme: name      # only when the `:colorscheme` name differs from the key
```

Available: `catppuccin-frappe`, `catppuccin-latte` (light), `catppuccin-macchiato`,
`catppuccin-mocha`, `tokyonight-day` (light), `tokyonight-moon`, `tokyonight-night`,
`tokyonight-storm`, `ayu-dark`, `ayu-mirage`, `ayu-light` (light), `kanagawa-wave`,
`kanagawa-dragon`, `kanagawa-lotus` (light), `onedark`, `onelight` (light), `nord`, `dracula`,
`0x96f`.

### How each tool gets its theme

| Mechanism | Tools |
| --- | --- |
| Theme file deployed next to the tool's config; the tool selects it by file name | bat, btop, opencode, yazi |
| Theme merged into the tool's config at render time | eza, fzf, herdr, lazygit |
| Value read straight from the registry | ghostty (`ghostty`), neovim (`nvim`), delta and macOS appearance (`light`) |

Only the active theme's files reach `~/.config`. `home/.chezmoiignore` hides the other eighteen, and
a script removes the previous theme's files after a switch. `home/.chezmoidata/theme-assets.yaml`
records where each tool keeps its per-theme asset; the assertion, the ignore file, the prune
script and the bat cache hash all read it.

### Adding a theme

1. Add an entry to `themes.yaml` with every field shown above. The key is also the Neovim
   `:colorscheme` name, so it must be a colorscheme the plugin ships; when the plugin selects
   the variant through `setup()` options instead, name the colorscheme with `nvim.colorscheme`.
2. Add the theme's asset for each tool listed in `theme-assets.yaml`, named exactly like the
   registry key (bat, btop, opencode and yazi select by file name). Two rules the assertion does
   not check: a yazi flavor also needs a `tmtheme.xml` beside its `flavor.toml` (a copy of the
   bat theme works), and the herdr asset's `name` must be one of herdr's built-in themes, with
   anything else remapped under `[theme.custom]`.
3. Run `chezmoi apply`. The coverage assertion fails, listing each missing asset, until every
   tool has one; eza and lazygit assets must also parse as YAML.

The theme picker at `chezmoi init` reads the registry, so nothing else needs updating. Assets
copied from another project carry a first-line comment naming the source and its licence.

### Switching

`theme` (in `~/.local/bin`) is the one front door: it records the choice in
`~/.config/chezmoi/chezmoi.toml`, forgets chezmoi's records of the target theme's pruned assets
(otherwise apply asks, per file, before rewriting a file it remembers writing), runs
`chezmoi apply`, reloads running herdr, Ghostty and Neovim instances live (herdr clients are nudged with SIGWINCH so panes repaint in the new palette), and lists the
tools that need a restart. Tools' own theme pickers are not used: four of the eight themed tools
have none, and anything switched inside a tool is overwritten by the next apply.

## Packages

`home/.chezmoidata/packages.yaml` lists taps, formulae, casks and Mac App Store apps. It renders
to `~/.config/homebrew/Brewfile`, which `HOMEBREW_BUNDLE_FILE` points at, so `brew bundle`
commands work without `--file`. The install script runs on every apply, on purpose: if something
was uninstalled by hand, the next apply restores it. `brew bundle check` keeps the no-op case
fast.

Language runtimes are mise's job (`home/dot_config/mise/config.toml`), never Homebrew's. Claude
Code is the one tool installed by its own script, since it is not packaged for either.

## Shell

`~/.zshenv` only sets `ZDOTDIR=~/.config/zsh` and sources the `.zshenv` there. That indirection
matters: a nested shell starts with `ZDOTDIR` already set and reads `$ZDOTDIR/.zshenv` directly,
never `~/.zshenv`, so keeping the environment in `ZDOTDIR` is what makes nested shells behave like
the first one. Under `~/.config/zsh`:

| File | Purpose |
| --- | --- |
| `.zshenv` | Environment only: locale, editor, XDG directories, `FZF_DEFAULT_OPTS_FILE`, `HOMEBREW_BUNDLE_FILE`, and `typeset -U path` so PATH never accumulates duplicates |
| `.zprofile` | Login PATH: Homebrew, Docker Desktop CLI, JetBrains Toolbox, each guarded |
| `.zshrc` | oh-my-zsh, then sources `conf.d/*.zsh` in name order |
| `conf.d/10-path.zsh` | `~/.local/bin` |
| `conf.d/20-tools.zsh` | chezmoi completions, zoxide, mise, fzf key bindings and previews, eza config dir |
| `conf.d/30-aliases.zsh` | `p` (Projects), `ls`/`ll`/`la`/`lt` (eza), `vim` (nvim), `cat` (bat), `y` (yazi), `uuid` |
| `conf.d/40-drift-notice.zsh` | One-line notice when the last drift check found differences |

oh-my-zsh is cloned once by chezmoi (`.chezmoiexternal.toml`, shallow) and then updates itself: it
asks in the terminal every 13 days, and `omz update` works at any time. chezmoi never pulls that
clone, so the two never fight. The syntax-highlighting plugin lives in `~/.config/oh-my-zsh` as a
pinned external, runtime caches go to `~/.cache/oh-my-zsh`, completion dumps to `~/.cache/zsh`.

## Guard rails

### Scripts, in execution order

| Script | Runs | Does |
| --- | --- | --- |
| `run_before_00-assert-theme-coverage` | every apply, before files | Template-only. Renders to nothing when the registry is consistent; otherwise `fail` aborts the apply before anything is written |
| `run_after_10-install-packages` | every apply | `brew bundle check`, then `brew bundle install` if needed; App Store entries may fail without failing the apply |
| `run_after_20-install-claude-code` | every apply, exits at once when installed | Official installer, stable channel, downloaded to a file before it runs |
| `run_onchange_after_30-mise-install` | when mise config changes | `mise install` |
| `run_onchange_after_40-bat-rebuild-cache` | when bat config or the active theme changes | `bat cache --build` |
| `run_onchange_after_50-prune-inactive-themes` | when the theme or registry changes | Removes the previous theme's files |
| `run_onchange_after_60-configure-macos-defaults` | when its content changes | Finder, Dock, Terminal, screenshots; restarts Finder and Dock |
| `run_onchange_after_65-macos-appearance` | when the theme's light/dark flag changes | Light or dark system appearance |
| `run_onchange_after_70-load-drift-check-agent` | when the plist changes | Loads the drift-check LaunchAgent and runs the first check |

### Theme assertion

Before any file is written, the assertion checks that the selected theme is registered, that
every registered theme has an asset for every tool in `theme-assets.yaml` plus the
`ghostty` and `nvim` fields, and that no tool directory holds an asset for an unregistered
theme. Failure looks like:

```
chezmoi: template: ... error calling fail: theme registry has themes without assets (theme / tool / expected path)

  - my-new-theme           bat       dot_config/bat/themes/my-new-theme.tmTheme
  - my-new-theme           yazi      dot_config/yazi/flavors/my-new-theme.yazi/flavor.toml
```

### Continuous integration

`.github/workflows/ci.yml` renders the tree once per theme on a Linux runner into a scratch
directory: apply, verify, render every script and check it with `bash -n` and shellcheck,
syntax-check the rendered zsh and Lua. A single macOS job repeats the apply, parses the
Brewfile with `brew bundle list`, and runs `stylua --check` on the Lua sources. Scripts never execute
and externals are skipped, so CI needs no secrets and touches no real machine.

### Drift detection

The LaunchAgent `io.chezmoi.drift-check` runs `~/.local/bin/chezmoi-drift-check` daily at 10:00
(or at the next wake). It runs `chezmoi status` over every managed target and catches both local
edits that never reached the repository and
pulled changes not yet applied. On drift it posts a notification, writes the list to
`~/.cache/chezmoi/drift`, and the next shell prints a one-line notice. The shell cost is a single
file test; the check itself never runs in the shell.

## Repository layout

```text
~/.local/share/chezmoi/
├── .github/workflows/ci.yml       # CI (see Guard rails)
├── .editorconfig                  # Indentation rules; stylua and CI enforce the Lua ones
├── LICENSE                        # MIT
├── home/                          # chezmoi source root (.chezmoiroot)
│   ├── .chezmoi.toml.tmpl         # Prompts once; writes ~/.config/chezmoi/chezmoi.toml
│   ├── .chezmoidata/
│   │   ├── packages.yaml          # Taps, formulae, casks, App Store apps
│   │   ├── theme-assets.yaml      # Where each tool keeps its per-theme asset
│   │   └── themes.yaml            # Theme registry
│   ├── .chezmoiexternal.toml      # oh-my-zsh (git clone, self-updating), zsh-syntax-highlighting (pinned)
│   ├── .chezmoiignore             # Hides inactive themes
│   ├── .chezmoiremove             # Old targets removed on apply
│   ├── .chezmoiscripts/           # Numbered scripts (see Guard rails)
│   ├── .chezmoitemplates/themes/  # eza, fzf, lazygit theme inputs (merged, never deployed)
│   ├── .chezmoiversion            # Minimum chezmoi version
│   ├── dot_config/                # ~/.config: bat, btop, eza, fzf, ghostty, homebrew, lazygit,
│   │                              #   mise, nvim, opencode, yazi, zsh
│   ├── dot_gitconfig.tmpl         # git + delta
│   ├── dot_gitignore              # Global gitignore
│   ├── dot_local/bin/             # chezmoi-drift-check
│   ├── dot_zshenv                 # Bootstrap: sets ZDOTDIR, sources ~/.config/zsh/.zshenv
│   ├── empty_dot_hushlogin        # Silences the login banner
│   ├── Projects/.keep             # Creates ~/Projects (target of the `p` alias); .keep itself is not deployed
│   └── private_Library/LaunchAgents/  # io.chezmoi.drift-check.plist
└── README.md
```

Conventions: data files under `.chezmoidata` describe *what*, templates describe *how*, scripts
describe *when*. Only `~/Library` carries the `private_` attribute; it is a directory macOS itself
keeps at 0700.

## Troubleshooting

**Apply asks "has changed since chezmoi last wrote it".** A managed file was edited outside the
repository. `diff` shows what differs; `overwrite` takes the repository version; `skip` keeps the
local one, after which `chezmoi add <path>` brings the edit into the repository.

**The theme did not change everywhere.** Run `chezmoi apply -v` and open a new terminal (`exec
zsh`). bat needs its cache rebuilt, which the apply does automatically; `bat cache --build` forces
it.

**A package is not installing, or the first apply stopped after Homebrew.** The install script runs
on every apply and stops the apply when a formula or cask fails, so the scripts after it (Claude
Code, mise, bat cache, macOS defaults, drift agent) did not run on that pass. The usual cause on a
new Mac is an app already present in `/Applications`, for example copied over by hand or by
Migration Assistant; brew names the cask in its output. Remove that app or the cask entry, then run
`chezmoi apply` again; everything that was skipped runs then. `chezmoi apply -v` shows brew's full
output. If an `onchange` script is stuck in a bad recorded state:
`chezmoi state delete-bucket --bucket=scriptState`, then apply again.

**No drift notification appears.** macOS asks once whether osascript may send notifications, on
the first check after install. If it was dismissed: System Settings → Notifications → Script Editor
(or osascript) → Allow. The shell notice works regardless.

**The drift notice keeps appearing.** It reflects the last daily check. After reconciling with
`chezmoi apply` or `chezmoi add`, run `chezmoi-drift-check` to clear it. Inspect the agent with
`launchctl print gui/$(id -u)/io.chezmoi.drift-check`; its log is `~/.cache/chezmoi/drift-check.log`.

**Apply fails on `~/.oh-my-zsh` (not a git repository).** The machine still has the old extracted
archive from before oh-my-zsh became a git clone. Remove it once and apply again: `rm -rf
~/.oh-my-zsh && chezmoi apply`. Nothing of yours lives in that directory.

## Acknowledgments

[chezmoi](https://www.chezmoi.io/) · [LazyVim](https://www.lazyvim.org/) · [oh-my-zsh](https://ohmyz.sh/) ·
[Catppuccin](https://catppuccin.com/) · [TokyoNight](https://github.com/folke/tokyonight.nvim) ·
[ayu](https://github.com/ayu-theme/ayu-colors) · [Kanagawa](https://github.com/rebelot/kanagawa.nvim) ·
[Atom One](https://github.com/navarasu/onedark.nvim) · [Nord](https://www.nordtheme.com/) ·
[Dracula](https://draculatheme.com/) · [0x96f](https://github.com/filipjanevski/0x96f.nvim)

Theme ports from [ayu-bat](https://github.com/mathiasdonoso/ayu-bat), [btop](https://github.com/aristocratos/btop),
[eza-themes](https://github.com/eza-community/eza-themes), [onehalf](https://github.com/sonph/onehalf),
[opencode](https://github.com/anomalyco/opencode) and the yazi flavors by
[kmlupreti](https://github.com/kmlupreti/ayu-dark.yazi), [dangooddd](https://github.com/dangooddd/kanagawa.yazi),
[marcosvnmelo](https://github.com/marcosvnmelo/kanagawa-dragon.yazi),
[muratoffalex](https://github.com/muratoffalex/kanagawa-lotus.yazi) and
[damjee](https://github.com/damjee/onedark.yazi); each file names its source.

MIT licensed. Take whatever is useful.
