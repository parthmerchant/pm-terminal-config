# pm-terminal-config

Portable terminal setup: zsh + oh-my-zsh + znap + oh-my-posh + neovim.

## Quick start (fresh macOS machine)

```sh
git clone https://github.com/parthmerchant/pm-terminal-config.git ~/pm-terminal-config
cd ~/pm-terminal-config
./install.sh
```

`install.sh` is idempotent — safe to re-run. It will:

1. Install Homebrew if missing
2. `brew install` the toolchain:
   - Shell: `git`, `zsh`, `neovim`, `nvm`, `oh-my-posh`, `fzf`, `jq`, `coreutils`, `wget`
   - Languages: `node`, `python@3.12`
   - LSP: `pyright` (Python — used by `nvim/lua/python_lsp.lua`)
   - Infra: `kubectl`, `terraform`, `awscli`
   - Casks: `docker` (Docker Desktop), `font-fira-code-nerd-font`
3. `npm install -g @anthropic-ai/claude-code` for the Claude Code CLI
4. Install `oh-my-zsh`, `znap`, and `vim-plug` for neovim
5. Symlink the configs from this repo into `$HOME` (backing up anything already there)
6. Run `nvim --headless "+PlugInstall" +qa` to materialize plugins

Then set zsh as your default shell: `chsh -s "$(command -v zsh)"` and open a new terminal.

## Layout

```
.
├── install.sh          # bootstrap script
├── nvim/               # → ~/.config/nvim
│   ├── init.lua
│   └── lua/*.lua
├── posh/               # → ~/poshconfig
│   ├── pm.json
│   └── pm2.json        # the prompt theme the zshrc loads by default
├── vim/vimrc           # legacy vim config (not linked by install.sh)
└── zsh/
    ├── zshrc           # → ~/.zshrc
    ├── zprofile        # → ~/.zprofile
    └── zshenv          # → ~/.zshenv
```

## Secrets

Do **not** commit API keys or tokens. The `zshrc` auto-sources `~/.zshrc.secrets` if it exists. Create it locally:

```sh
touch ~/.zshrc.secrets
chmod 600 ~/.zshrc.secrets
```

Then add lines like:

```sh
export OPENAI_API_KEY='...'
export DD_API_KEY='...'
```

## Python LSP in neovim

`nvim/lua/python_lsp.lua` wires up **pyright** (via `nvim-lspconfig` on the `vim.lsp.config` API, nvim 0.11+) and **nvim-cmp** for autocomplete with **auto-import** on completion accept.

Virtualenv detection, in order of precedence:

1. `$VIRTUAL_ENV` (i.e. you ran `source .venv/bin/activate`)
2. `./.venv/` in the current working directory
3. `./venv/` in the current working directory
4. System `python3` as fallback

When a venv is found, pyright is told to use that interpreter for resolving imports and type stubs. Open any `.py` file in a project with a `.venv` and pyright will attach automatically.

LSP keymaps (set on `LspAttach`):

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover docs |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action (incl. auto-import) |
| `<leader>f` | Format buffer |

## Prompt

The zshrc loads `~/poshconfig/pm2.json`. Swap to `pm.json` by editing the `oh-my-posh init` line in `zsh/zshrc`.

## Nerd Font

Install a Nerd Font for the prompt glyphs and devicons to render:

```sh
brew install --cask font-fira-code-nerd-font
```

Then set it as the terminal font in iTerm2 / Ghostty / Terminal.app.

## Updating

```sh
cd ~/pm-terminal-config && git pull
```

Symlinks re-point automatically — no re-install needed unless deps changed.
