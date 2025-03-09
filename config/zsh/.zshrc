#!/bin/zsh

autoload -U compinit

_has_command() {
  local name="$1"
  command -v "${name}" > /dev/null 2>&1
}

# Starship
if _has_command starship; then
  eval "$(starship init zsh)"
fi

# Carapace
if _has_command carapace; then
  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
  zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
  source <(carapace _carapace)
fi

# mise
if _has_command mise; then
  eval "$(mise activate zsh)"
fi

# Dependency
if [[ -f "${DOTFILES2_ZSHRC}" ]]; then
  source "${DOTFILES2_ZSHRC}"
fi
