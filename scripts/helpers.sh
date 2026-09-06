#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR_HELPERS="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT_HELPERS="$(cd -- "${SCRIPT_DIR_HELPERS}/.." && pwd)"

log()  { printf '[INFO] %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*" >&2; }
die()  { printf '[ERROR] %s\n' "$*" >&2; exit 1; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

abspath() {
  local target=$1
  if command -v realpath >/dev/null 2>&1; then
    realpath -m -- "$target"
  else
    python3 - "$target" <<'PY'
import os, sys
print(os.path.abspath(sys.argv[1]))
PY
  fi
}

safe_mkdir() {
  local dir=$1
  [[ -d "$dir" ]] || mkdir -p -- "$dir"
}

load_config() {
  local config_file=${1:-"${PROJECT_ROOT_HELPERS}/config/local.env"}
  if [[ -f "$config_file" ]]; then
    # shellcheck disable=SC1090
    source "$config_file"
    log "Loaded config: $config_file"
  fi
}

print_kv() {
  printf '  %-18s %s\n' "$1" "$2"
}
