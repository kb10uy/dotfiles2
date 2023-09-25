use epm
use str

set paths = [
  $E:HOME'/.cargo/bin'
  $E:HOME'/.local/bin'
  $E:HOME'/.fzf/bin'
  '/usr/local/go/bin'
  '/usr/local/ssl/bin'
  '/usr/local/bin'
  '/usr/bin'
  '/bin'
  '/sbin'
]

eval (starship init elvish)
