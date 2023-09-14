set -x EDITOR 'nvim'
set -x VISUAL 'nvim'
set -x PYTHON3_PATH '/usr/bin/python3'
set -x HOMEBREW_NO_AUTO_UPDATE 1
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_CACHE_HOME "$HOME/.cache"
set -x XDG_DATA_HOME "$HOME/.local/share"

set -x PATH \
  $HOME/.cargo/bin \
  $HOME/.local/bin \
  $HOME/.fzf/bin \
  /opt/homebrew/bin \
  /usr/local/bin \
  /usr/bin \
  /bin
