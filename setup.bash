#!/bin/bash

readonly DOTFILES2_DIR="$(cd $(dirname $0) && pwd)"

# Log functions

exit_fatal() {
  echo -e "\e[31;1;7m FATAL \e[0m $1"
  exit 1
}

log_info() {
  echo -e "\e[32;47m INFO \e[0m $1"
}

log_warn() {
  echo -e "\e[37;43m WARN \e[0m $1"
}

# Task functions

make_config_symlink() {
  local base_dir="${DOTFILES2_DIR}/config/$1"
  local target_dir="${HOME}/.config/$1"

  if [[ -e "${target_dir}" ]]; then
    log_warn "symlink target '${target_dir}' already exists"
  else
    ln -s "${base_dir}" "${target_dir}"
  fi
}


# Section functions

check_base_directory() {
  if [[ "${DOTFILES2_DIR}" != "${HOME}/dotfiles2" ]]; then
    exit_fatal "repositiory directory must be '${HOME}/dotfiles2'"
  fi
}

make_directories() {
  log_info "making XDG directories"
  mkdir -p "${HOME}/.config"
  mkdir -p "${HOME}/.local"
}

link_config_directories() {
  make_config_symlink "fish"
  make_config_symlink "nvim"
  make_config_symlink "nano"
}

main() {
  check_base_directory
  make_directories
  link_config_directories
}

main
