#!/bin/bash

readonly DOTFILES2_DIR="$(cd $(dirname $0) && pwd)"

# Log functions

exit_fatal() {
  echo -e "\e[31;1;7m FATAL \e[0m $1"
  exit 1
}

log_warn() {
  echo -e "\e[37;43m WARN \e[0m $1"
}

log_info() {
  echo -e "\e[32;47m INFO \e[0m $1"
}

log_success() {
  echo -e "\e[37;44;1m SUCC \e[0m $1"
}

# Task functions

get_distro() {
  echo "$(source /etc/os-release && echo ${ID})"
}

make_config_symlink() {
  local base_dir="${DOTFILES2_DIR}/config/$1"
  local target_dir="${HOME}/.config/$1"

  if [[ -e "${target_dir}" ]]; then
    log_warn "symlink target '${target_dir}' already exists"
  else
    ln -s "${base_dir}" "${target_dir}"
  fi
}

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

install_rust() {
  if [[ -e "${HOME}/.cargo" ]]; then
    log_warn "Rust toolchain already installed"
    return 0
  fi

  # install build essentials
  log_info "installing build tools"
  case "$(get_distro)" in
    "debian")
      sudo apt-get -y install build-essential
      ;;
    "ubuntu")
      sudo apt-get -y install build-essential
      ;;
    "arch")
      sudo pacman -S base-devel
      ;;
    *)
      log_info "extra package manager skipped"
      ;;
  esac

  # install Rust without modifying PATH
  log_info "installing Rust toolchain with rustup"
  local setup_file="$(mktemp)"
  curl --proto "=https" --tlsv1.2 -sSf "https://sh.rustup.rs" > "${setup_file}"
  sh "${setup_file}" -y --no-modify-path
  rm "${setup_file}"
}

install_extra_package_manager() {
  case "$(get_distro)" in
    "debian")
      log_info "installing snapd"
      sudo apt-get -y install snapd
      ;;
    "ubuntu")
      log_info "installing snapd"
      sudo apt-get -y install snapd
      ;;
    "arch")
      log_info "installing paru"
      "${HOME}/.cargo/bin/cargo" install paru
      ;;
    *)
      log_info "extra package manager skipped"
      ;;
  esac
}

install_neovim() {
  log_info "installing Neovim"
  case "$(get_distro)" in
    "debian")
      sudo snap install --classic nvim
      ;;
    "ubuntu")
      sudo snap install --classic nvim
      ;;
    "arch")
      paru -S --noconfirm neovim
      ;;
  esac
}

install_fish() {
  log_info "installing fish"
  case "$(get_distro)" in
    "debian")
      sudo apt-get -y install fish
      chsh -s "/usr/bin/fish"
      ;;
    "ubuntu")
      sudo apt-get -y install fish
      chsh -s "/usr/bin/fish"
      ;;
    "arch")
      paru -S --noconfirm fish
      chsh -s "/usr/bin/fish"
      ;;
  esac
}

install_extra_tools() {
  log_info "installing extra tools"

  # fzf
  log_info "=> fzf"
  git clone --depth 1 "https://github.com/junegunn/fzf.git" "${HOME}/.fzf"
  "${HOME}/.fzf/install" --no-key-bindings --no-completion --no-update-rc --no-fish --no-bash

  # ripgrep
  case "$(get_distro)" in
    "debian")
      sudo apt-get -y install ripgrep
      ;;
    "ubuntu")
      sudo apt-get -y install ripgrep
      ;;
    "arch")
      paru -S --noconfirm ripgrep
      ;;
  esac
}

# Main routine

main() {
  check_base_directory
  log_info "detected distro: $(get_distro)"

  make_directories
  link_config_directories

  install_rust
  install_extra_package_manager
  install_neovim
  install_fish
  install_extra_tools

  log_success "dotfiles2 setup finished!"
}

main
