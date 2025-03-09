#!/bin/zsh

path=(
  "${HOME}/.cargo/bin"
  "${HOME}/.juliaup/bin"
  "${HOME}/.fzf/bin"
  "${HOME}/.local/bin"
  $path
)
export PATH
