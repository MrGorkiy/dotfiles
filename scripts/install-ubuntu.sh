#!/usr/bin/env bash
set -euo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common.sh"
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

if [[ "${EUID}" == "0" ]]; then
  SUDO=()
else
  SUDO=(sudo)
fi

apt_install_available() {
  local package
  local available=()
  for package in "$@"; do
    if apt-cache show "$package" >/dev/null 2>&1; then
      available+=("$package")
    else
      warn "APT package unavailable on this Ubuntu release: $package"
    fi
  done
  ((${#available[@]})) && run "${SUDO[@]}" apt-get install -y "${available[@]}"
}

log 'Refreshing APT metadata.'
run "${SUDO[@]}" apt-get update

# Packages shipped by Ubuntu. The remaining Rust CLI tools are downloaded as
# prebuilt binaries below, so a local compiler toolchain is not required.
apt_install_available \
  ca-certificates curl git zsh fzf fd-find ripgrep bat jq zoxide btop ncdu tmux \
  lnav hyperfine unzip tar xz-utils

# Debian-family packages deliberately use fdfind/batcat to avoid collisions.
# Put compatibility links in ~/.local/bin instead of modifying /usr/bin.
link_compat_binary() {
  local target="$1" source_command="$2" source_path destination
  command_exists "$target" && return
  command_exists "$source_command" || return
  source_path="$(command -v "$source_command")"
  destination="$HOME/.local/bin/$target"
  if [[ -e "$destination" || -L "$destination" ]]; then
    warn "Keeping existing compatibility path: $destination"
    return
  fi
  run mkdir -p "$HOME/.local/bin"
  run ln -s "$source_path" "$destination"
}
link_compat_binary fd fdfind
link_compat_binary bat batcat

install_binstall() {
  command_exists cargo-binstall && return 0
  if [[ "${DOTFILES_DRY_RUN:-0}" == "1" ]]; then
    log 'Would install cargo-binstall, which downloads prebuilt Rust CLI binaries.'
    return 0
  fi
  log 'Installing cargo-binstall for prebuilt Rust CLI binaries.'
  curl --proto '=https' --tlsv1.2 --fail --silent --show-error --location \
    https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh \
    | bash
  command_exists cargo-binstall
}

install_binary_if_missing() {
  local command_name="$1" package_name="$2"
  if command_exists "$command_name"; then
    log "Already installed: $command_name"
  else
    log "Downloading prebuilt CLI package: $package_name"
    run cargo-binstall --no-confirm "$package_name"
  fi
}

if install_binstall; then
  install_binary_if_missing eza eza
  install_binary_if_missing dust du-dust
  install_binary_if_missing xh xh
  install_binary_if_missing watchexec watchexec-cli
  install_binary_if_missing delta git-delta
  install_binary_if_missing btm bottom
  install_binary_if_missing procs procs
  install_binary_if_missing atuin atuin
  install_binary_if_missing tldr tealdeer
else
  warn 'cargo-binstall could not be prepared; eza, dust, xh, watchexec, delta, bottom, procs, Atuin and tldr were not installed.'
fi

# mikefarah/yq publishes portable binaries; this avoids the unrelated Python
# package and Snap confinement on Ubuntu.
if ! command_exists yq; then
  case "$(uname -m)" in
    x86_64) yq_arch=amd64 ;;
    aarch64|arm64) yq_arch=arm64 ;;
    *) warn "No yq binary mapping for architecture: $(uname -m)"; yq_arch= ;;
  esac
  if [[ -n "${yq_arch:-}" ]]; then
    run mkdir -p "$HOME/.local/bin"
    run curl --fail --location --output "$HOME/.local/bin/yq" \
      "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${yq_arch}"
    run chmod +x "$HOME/.local/bin/yq"
  fi
fi

install_lazygit() {
  local archive arch asset_url temp_dir
  command_exists lazygit && return
  if [[ "${DOTFILES_DRY_RUN:-0}" == "1" ]]; then
    log 'Would download the latest lazygit release to ~/.local/bin/lazygit.'
    return
  fi
  case "$(uname -m)" in
    x86_64) arch=x86_64 ;;
    aarch64|arm64) arch=arm64 ;;
    *) warn "No lazygit release mapping for architecture: $(uname -m)"; return ;;
  esac
  asset_url="$(curl --fail --silent --show-error --location \
    https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
    | grep -Eo '"browser_download_url": "[^"]+Linux_'"$arch"'\.tar\.gz"' \
    | head -n1 | sed -E 's/"browser_download_url": "(.*)"/\1/' || true)"
  if [[ -z "$asset_url" ]]; then
    warn 'Could not resolve a lazygit release asset.'
    return
  fi
  temp_dir="$(mktemp -d)"
  archive="$temp_dir/lazygit.tar.gz"
  curl --fail --location --output "$archive" "$asset_url"
  tar -xzf "$archive" -C "$temp_dir" lazygit
  mkdir -p "$HOME/.local/bin"
  install -m 0755 "$temp_dir/lazygit" "$HOME/.local/bin/lazygit"
  rm -rf "$temp_dir"
}

install_gh() {
  local key_file=/usr/share/keyrings/githubcli-archive-keyring.gpg
  local source_file=/etc/apt/sources.list.d/github-cli.list
  local temp_key architecture
  command_exists gh && return
  if [[ "${DOTFILES_DRY_RUN:-0}" == "1" ]]; then
    log 'Would configure the official GitHub CLI APT source and install gh.'
    return
  fi
  architecture="$(dpkg --print-architecture)"
  temp_key="$(mktemp)"
  curl --fail --silent --show-error --location \
    https://cli.github.com/packages/githubcli-archive-keyring.gpg --output "$temp_key"
  "${SUDO[@]}" install -Dm 0644 "$temp_key" "$key_file"
  rm -f "$temp_key"
  printf 'deb [arch=%s signed-by=%s] https://cli.github.com/packages stable main\n' \
    "$architecture" "$key_file" | "${SUDO[@]}" tee "$source_file" >/dev/null
  "${SUDO[@]}" apt-get update
  "${SUDO[@]}" apt-get install -y gh
}

install_lazygit
install_gh

install_shell_plugins
