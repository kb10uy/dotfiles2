#!/bin/bash
set -e

readonly DOTFILES2_DIR="$(cd $(dirname $0) && pwd)"
declare -A DISTRO

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
  if [[ -z "${DISTRO["os"]}" ]]; then
    case "$(uname)" in
      "Linux")
        DISTRO["os"]="$(source /etc/os-release && echo ${ID})"
        DISTRO["version"]="$(source /etc/os-release && echo ${VERSION_ID})"
        DISTRO["versioncode"]="$(source /etc/os-release && echo ${VERSION_CODENAME})"
        ;;
      "Darwin")
        DISTRO["os"]="macos"
        DISTRO["version"]="$(sw_vers --productVersion)"
        DISTRO["versioncode"]=""
        ;;
      *)
        log_fatal "unsupported OS"
        ;;
    esac
  fi
  echo "${DISTRO[$1]}"
}

make_config_symlink() {
  local base_dir="${DOTFILES2_DIR}/config/$1"
  local target_dir="${HOME}/.config/$1"

  if [[ -e "${target_dir}" ]]; then
    log_warn "symlink target '${target_dir}' already exists"
  else
    log_info "linking config directory '$1'"
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
  make_config_symlink "elvish"
  make_config_symlink "starship.toml"
}

install_rust() {
  if [[ -e "${HOME}/.cargo" ]]; then
    log_info "updating Rust toolchain"
    "${HOME}/.cargo/bin/rustup" update
    return 0
  fi

  # install build essentials
  log_info "installing build tools"
  case "$(get_distro os)" in
    "debian")
      sudo apt-get -y install build-essential
      ;;
    "ubuntu")
      sudo apt-get -y install build-essential
      ;;
    "arch")
      sudo pacman -S base-devel
      ;;
    "macos")
      log_warn "xcode-select --install must be executed before"
      ;;
    *)
      log_warn "build tools skipped"
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
  case "$(get_distro os)" in
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
    "macos")
      log_info "installing brew"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      ;;
    *)
      log_info "extra package manager skipped"
      ;;
  esac
}

install_neovim() {
  log_info "installing Neovim"
  case "$(get_distro os)" in
    "debian")
      sudo snap install --classic nvim
      ;;
    "ubuntu")
      sudo snap install --classic nvim
      ;;
    "arch")
      paru -S --noconfirm neovim
      ;;
    "macos")
      brew install neovim
      ;;
  esac
}

install_fish() {
  log_info "installing fish"
  case "$(get_distro os)" in
    "debian")
      sudo apt-get -y install fish
      chsh -s "/usr/bin/fish"
      ;;
    "ubuntu")
      sudo add-apt-repository ppa:fish-shell/release-3
      sudo apt update
      sudo apt-get -y install fish
      chsh -s "/usr/bin/fish"
      ;;
    "arch")
      paru -S --noconfirm fish
      chsh -s "/usr/bin/fish"
      ;;
    "macos")
      brew install fish
      chsh -s "/usr/local/bin/fish"
      ;;
  esac
}

install_extra_tools() {
  log_info "installing extra tools"

  # fzf
  log_info "=> fzf"
  if [[ ! -e "${HOME}/.fzf" ]]; then
    git clone --depth 1 "https://github.com/junegunn/fzf.git" "${HOME}/.fzf"
  else
    pushd "${HOME}/.fzf"
      git pull origin master
    popd
  fi
  "${HOME}/.fzf/install" --no-key-bindings --no-completion --no-update-rc --no-fish --no-bash

  # eza
  log_info "=> eza"
  "${HOME}/.cargo/bin/cargo" install eza

  # starship
  log_info "=> starship"
  "${HOME}/.cargo/bin/cargo" install starship

  # ripgrep
  log_info "=> ripgrep, fd, bat, procs"
  case "$(get_distro os)" in
    "debian")
      sudo apt-get -y install ripgrep fd-find bat
      sudo snap install procs
      ;;
    "ubuntu")
      sudo apt-get -y install ripgrep fd-find bat
      sudo snap install procs
      ;;
    "arch")
      paru -S --noconfirm ripgrep fd bat procs
      ;;
    "macos")
      brew install ripgrep fd bat procs
      ;;
  esac
}

# Main routine

main() {
  check_base_directory
  log_info "detected distro: $(get_distro os)"

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
