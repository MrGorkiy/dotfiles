#!/usr/bin/env bash
# Conventional first-run entry point. It intentionally delegates all work to
# install.sh so both commands have the same options and idempotent behaviour.
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
exec "$repo_dir/install.sh" "$@"
