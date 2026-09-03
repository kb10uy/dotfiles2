#!/bin/zsh

_has_command() {
  local name="$1"
  command -v "${name}" > /dev/null 2>&1
}


# Options
# setopt's option names are case-insensitive and underscore-agnostic. (using snake_case)

## Behavior
setopt auto_cd

## Command History
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history
setopt hist_reduce_blanks
setopt hist_no_store

## History Search
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end
### zle puts the terminal into application cursor mode (terminfo smkx),
### where the arrow keys send ^[OA / ^[OB instead of ^[[A / ^[[B.
bindkey "^[OA" history-beginning-search-backward-end
bindkey "^[OB" history-beginning-search-forward-end

## Completions
autoload -U compinit
compinit -d "${XDG_CACHE_HOME}/.zcompdump"


# Shell Tools

## Starship
if _has_command starship; then
  eval "$(starship init zsh)"
fi

## sheldon (zsh plugins)
if _has_command sheldon; then
  eval "$(sheldon source)"
fi

## pay-respects
if _has_command pay-respects; then
  eval "$(pay-respects zsh --alias)"
fi

## FZF
if _has_command fzf; then
  source <(fzf --zsh)
fi

## mise
if _has_command mise; then
  eval "$(mise activate zsh)"
fi


# Environment Dependency
if [[ -f "${DOTFILES2_ZSHRC}" ]]; then
  source "${DOTFILES2_ZSHRC}"
fi
