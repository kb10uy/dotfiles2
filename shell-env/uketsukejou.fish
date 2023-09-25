set -x LANG 'ja_JP.UTF-8'
set -x EDITOR 'nvim'
set -x VISUAL 'nvim'
set -x JAVA_HOME '/usr/lib/jvm/'(archlinux-java get)
set -x DOTNET_ROOT '/usr/share/dotnet'
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_CACHE_HOME "$HOME/.cache"
set -x XDG_DATA_HOME "$HOME/.local/share"

set -x PATH \
  $HOME/.cargo/bin \
  $HOME/.local/bin \
  $HOME/.fzf/bin \
  /usr/local/go/bin \
  /usr/local/ssl/bin \
  /usr/local/bin \
  /usr/bin \
  /bin \
  /sbin
