#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/helpers.sh
source "${SCRIPT_DIR}/helpers.sh"

validate_input_dir() {
  local input_dir=$1
  [[ -n "$input_dir" ]] || die "Input directory is empty."
  [[ -d "$input_dir" ]] || die "Input directory does not exist: $input_dir"
  [[ -r "$input_dir" ]] || die "Input directory is not readable: $input_dir"

  if ! find "$input_dir" -type f -print -quit | grep -q .; then
    die "Input directory contains no files: $input_dir"
  fi
}

validate_subject_id() {
  local subject=$1
  [[ -n "$subject" ]] || die "Subject ID is required."
  [[ "$subject" =~ ^[A-Za-z0-9._-]+$ ]] || \
    die "Subject ID contains unsupported characters: $subject"
}

validate_output_target() {
  local output_dir=$1
  local force=${2:-0}

  if [[ -e "$output_dir" && "$force" -ne 1 ]]; then
    die "Output already exists: $output_dir (use --force to allow writing into it)"
  fi
}
