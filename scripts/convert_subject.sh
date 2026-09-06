#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/helpers.sh
source "${SCRIPT_DIR}/helpers.sh"

convert_subject() {
  local input_dir=$1
  local output_dir=$2
  local subject=$3
  local dry_run=${4:-0}

  local converter=${CONVERTER_BIN:-dcm2niix}
  local pattern=${DICOM_FILENAME_PATTERN:-%p_%s}
  local gzip=${DICOM_GZIP:-y}
  local overwrite=${DICOM_OVERWRITE:-n}
  local extra=${DICOM_EXTRA_ARGS:-}

  safe_mkdir "$output_dir"

  local cmd=("$converter" -b y -z "$gzip" -w "$overwrite" -f "$pattern" -o "$output_dir")
  if [[ -n "$extra" ]]; then
    # Intentional word splitting for user-supplied CLI flags from config.
    # shellcheck disable=SC2206
    local extra_args=( $extra )
    cmd+=("${extra_args[@]}")
  fi
  cmd+=("$input_dir")

  log "Subject: $subject"
  log "Input:   $input_dir"
  log "Output:  $output_dir"

  if [[ "$dry_run" -eq 1 ]]; then
    printf '[DRY RUN] '
    printf '%q ' "${cmd[@]}"
    printf '\n'
    return 0
  fi

  require_cmd "$converter"
  "${cmd[@]}"

  log "Conversion finished for $subject"
}
