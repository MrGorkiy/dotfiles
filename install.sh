#!/usr/bin/env bash
# Install the portable terminal setup on macOS or Ubuntu.
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
dry_run=0
link_only=0
skip_ghostty=0

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Options:
  --dry-run       Print the actions without changing the machine.
  --link-only     Only link configuration files; do not install packages/plugins.
  --skip-ghostty  On macOS, do not install the Ghostty app or font.
  -h, --help      Show this help.
EOF
}

while (($#)); do
  case "$1" in
    --dry-run) dry_run=1 ;;
    --link-only) link_only=1 ;;
    --skip-ghostty) skip_ghostty=1 ;;
    -h|--help) usage; exit 0 ;;
    *) printf 'Unknown option: %s\n' "$1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

export DOTFILES_REPO="$repo_dir"
export DOTFILES_DRY_RUN="$dry_run"
export DOTFILES_SKIP_GHOSTTY="$skip_ghostty"

printf '[dotfiles] Repository: %s\n' "$repo_dir"

if (( ! link_only )); then
  case "$(uname -s)" in
    Darwin) "$repo_dir/scripts/install-macos.sh" ;;
    Linux)
      if [[ -r /etc/os-release ]] && . /etc/os-release && [[ "${ID:-}" == "ubuntu" ]]; then
        "$repo_dir/scripts/install-ubuntu.sh"
      else
        printf '[dotfiles] Unsupported Linux distribution. Only Ubuntu is supported.\n' >&2
        exit 1
      fi
      ;;
    *) printf '[dotfiles] Unsupported operating system: %s\n' "$(uname -s)" >&2; exit 1 ;;
  esac
else
  printf '[dotfiles] Package and plugin installation skipped.\n'
fi

"$repo_dir/scripts/link-config.sh"

printf '\n[dotfiles] Done. Start a new shell with: exec zsh\n'
printf '[dotfiles] Read the command reference with: th\n'
