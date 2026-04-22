#!/usr/bin/env bash
# pm-terminal-config installer — idempotent bootstrap for a fresh macOS machine.
# Installs deps, then symlinks configs into $HOME. Safe to re-run.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.pm-terminal-config-backup-$(date +%Y%m%d-%H%M%S)"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[warn]\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m[err]\033[0m %s\n' "$*" >&2; exit 1; }

backup_and_link() {
  local src="$1" dest="$2"
  if [[ -L "$dest" ]] && [[ "$(readlink "$dest")" == "$src" ]]; then
    return 0
  fi
  if [[ -e "$dest" || -L "$dest" ]]; then
    mkdir -p "$BACKUP_DIR"
    log "backing up $dest -> $BACKUP_DIR/"
    mv "$dest" "$BACKUP_DIR/"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  log "linked $dest -> $src"
}

# 1. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  log "Homebrew present"
fi

# 2. Core packages
log "Installing core packages via brew"
# Terminal essentials + LSP + dev toolchain + language runtimes.
BREW_FORMULAE=(
  git zsh neovim nvm oh-my-posh fzf jq coreutils wget
  node python@3.12
  pyright            # Python LSP (used by nvim/lua/python_lsp.lua)
  kubectl
  terraform
  awscli
)
brew install "${BREW_FORMULAE[@]}" || warn "some brew packages may already be installed"

# Casks: GUI apps + fonts. Docker Desktop provides the `docker` CLI.
BREW_CASKS=(
  docker
  font-fira-code-nerd-font
)
for cask in "${BREW_CASKS[@]}"; do
  brew install --cask "$cask" || warn "cask $cask may already be installed or require manual approval"
done

# Claude Code CLI (requires node from the brew step above).
if command -v npm >/dev/null 2>&1; then
  if ! command -v claude >/dev/null 2>&1; then
    log "Installing Claude Code CLI"
    npm install -g @anthropic-ai/claude-code || warn "claude-code install failed — check npm permissions"
  else
    log "claude-code present"
  fi
else
  warn "npm not on PATH after brew install; skipping claude-code"
fi

# 3. oh-my-zsh (unattended)
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log "Installing oh-my-zsh"
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  log "oh-my-zsh present"
fi

# 4. znap
if [[ ! -d "$HOME/Repos/znap" ]]; then
  log "Cloning znap"
  mkdir -p "$HOME/Repos"
  git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git "$HOME/Repos/znap"
else
  log "znap present"
fi

# 5. vim-plug for neovim
PLUG_VIM="$HOME/.local/share/nvim/site/autoload/plug.vim"
if [[ ! -f "$PLUG_VIM" ]]; then
  log "Installing vim-plug for neovim"
  curl -fLo "$PLUG_VIM" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
  log "vim-plug present"
fi

# 6. fzf shell integration
if [[ ! -f "$HOME/.fzf.zsh" ]]; then
  FZF_INSTALL="$(brew --prefix)/opt/fzf/install"
  if [[ -x "$FZF_INSTALL" ]]; then
    log "Running fzf install"
    yes | "$FZF_INSTALL" --key-bindings --completion --no-update-rc || warn "fzf install returned non-zero"
  fi
fi

# 7. Link configs (backs up anything already there)
log "Linking config files"
backup_and_link "$REPO_DIR/zsh/zshrc"    "$HOME/.zshrc"
backup_and_link "$REPO_DIR/zsh/zprofile" "$HOME/.zprofile"
backup_and_link "$REPO_DIR/zsh/zshenv"   "$HOME/.zshenv"
backup_and_link "$REPO_DIR/nvim"         "$HOME/.config/nvim"
backup_and_link "$REPO_DIR/posh"         "$HOME/poshconfig"

# 8. Install nvim plugins
log "Installing neovim plugins (headless)"
nvim --headless "+PlugInstall --sync" +qa 2>/dev/null || \
  warn "PlugInstall had issues — open nvim and run :PlugInstall manually"

cat <<EOF

✅ Install complete.

Next steps:
  1. Set zsh as your default shell:
       chsh -s "\$(command -v zsh)"
  2. Open a new terminal (or: exec zsh).
  3. Install a Nerd Font and set it in your terminal profile, e.g.:
       brew install --cask font-fira-code-nerd-font
  4. If you use API keys, create ~/.zshrc.secrets with chmod 600 and export them:
       export OPENAI_API_KEY='...'
       export DD_API_KEY='...'
     It's auto-sourced by ~/.zshrc. NEVER commit this file.

Config backups (if any) are in: $BACKUP_DIR
EOF
