#!/bin/zsh

# Define XDG Base Directory variables explicitly
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_STATE_HOME="${HOME}/.local/state"

# Zsh history setting
export HISTFILE="${XDG_CACHE_HOME}/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=5000

# dotfiles2 common variables
export DOTFILES2_DIR="${HOME}/dotfiles2"
export DOTFILES2_DEP_NAME="$(hostname)"
export DOTFILES2_ZSHENV="${DOTFILES2_DIR}/shell-env/${DOTFILES2_DEP_NAME}.zshenv"
export DOTFILES2_ZSHRC="${DOTFILES2_DIR}/shell-env/${DOTFILES2_DEP_NAME}.zshrc"

# Dependency
if [[ -f "${DOTFILES2_ZSHENV}" ]]; then
  source "${DOTFILES2_ZSHENV}"
fi
