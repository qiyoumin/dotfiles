#!/usr/bin/env bash

set -eEuo pipefail

BASE_PROGRAMS=(git vim tmux)
LEGACY_PATHS=(
  "$HOME/.vim"
)
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

dry_run=0
check_only=0
selected_shell=""
backup_dir=""
rollback_enabled=0
rollback_in_progress=0
PROGRAMS=()
ENTRY_PATHS=()
configured_programs=()
restored_paths=()

log() {
  echo "$*"
}

warn() {
  echo "Warning: $*" >&2
}

usage() {
  cat <<'EOF'
Usage: ./setup_all.sh [--dry-run|-n] [--check] [--shell bash|zsh]

Options:
  --dry-run, -n  Preview changes without modifying $HOME.
  --check        Run dependency and stow preflight checks only.
  --shell        Override automatic shell selection.
EOF
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run|-n)
      dry_run=1
      shift
      ;;
    --check)
      check_only=1
      shift
      ;;
    --shell)
      if [ "$#" -lt 2 ]; then
        echo "Missing value for --shell. Use bash or zsh." >&2
        usage >&2
        exit 1
      fi
      selected_shell="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [ "$dry_run" -eq 1 ] && [ "$check_only" -eq 1 ]; then
  echo "Use either --dry-run or --check, not both." >&2
  usage >&2
  exit 1
fi

resolve_login_shell_path() {
  local shell_path=""

  if command -v getent >/dev/null 2>&1; then
    shell_path="$(getent passwd "$USER" | cut -d: -f7)"
  elif [ -r /etc/passwd ]; then
    shell_path="$(awk -F: -v user="$USER" '$1 == user { print $7; exit }' /etc/passwd)"
  elif [ -n "${SHELL:-}" ]; then
    shell_path="$SHELL"
  fi

  printf '%s\n' "$shell_path"
}

resolve_selected_shell() {
  local shell_name="$selected_shell"
  local detected_shell=""

  if [ -z "$shell_name" ]; then
    detected_shell="$(resolve_login_shell_path)"
    shell_name="$(basename "$detected_shell")"
  fi

  case "$shell_name" in
    bash|zsh)
      printf '%s\n' "$shell_name"
      ;;
    *)
      echo "Unsupported login shell: ${shell_name:-unknown}. Use --shell bash or --shell zsh." >&2
      exit 1
      ;;
  esac
}

set_managed_paths() {
  local shell_name="$1"

  PROGRAMS=("${BASE_PROGRAMS[@]}" "$shell_name")
  ENTRY_PATHS=(
    "$HOME/.gitconfig"
    "$HOME/.vimrc"
    "$HOME/.tmux.conf"
  )

  case "$shell_name" in
    bash)
      ENTRY_PATHS+=("$HOME/.bashrc")
      ;;
    zsh)
      ENTRY_PATHS+=("$HOME/.zshrc")
      ;;
  esac
}

require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "Missing dependency: $command_name" >&2
    exit 1
  fi
}

ensure_repo_layout() {
  local program=""

  for program in "${PROGRAMS[@]}"; do
    if [ ! -d "$REPO_ROOT/$program" ]; then
      echo "Missing managed directory: $program" >&2
      exit 1
    fi
  done
}

run_dependency_checks() {
  log "Running dependency checks"
  require_command stow
  require_command readlink
  ensure_repo_layout
}

run_stow_preflight() {
  local program=""
  local stow_args=(--dir="$REPO_ROOT" -v -n -R --target="$HOME")

  log "Running stow preflight"
  for program in "${PROGRAMS[@]}"; do
    stow "${stow_args[@]}" "$program"
    log "Preflight OK: $program"
  done
}

backup_if_exists() {
  local path="$1"
  local resolved_path=""

  if [ ! -e "$path" ] && [ ! -L "$path" ]; then
    return
  fi

  if [ -L "$path" ]; then
    resolved_path="$(readlink -f "$path")"
    case "$resolved_path" in
      "$REPO_ROOT"/*)
        return
        ;;
    esac
  fi

  if [ -z "$backup_dir" ]; then
    backup_dir="$REPO_ROOT/dotfile_bk_$(date -u +"%Y%m%d%H%M%S")"
    mkdir -p "$backup_dir"
    echo "Created backup directory: $backup_dir"
  fi

  mv "$path" "$backup_dir/"
  restored_paths+=("$path")
  log "Backed up $path"
}

cleanup_legacy_path() {
  local path="$1"
  local resolved_path=""

  if [ ! -e "$path" ] && [ ! -L "$path" ]; then
    return
  fi

  if [ -L "$path" ]; then
    resolved_path="$(readlink -f "$path")"
    case "$resolved_path" in
      "$REPO_ROOT"/*)
        rm "$path"
        echo "Removed legacy managed path $path"
        return
        ;;
    esac
  fi

  backup_if_exists "$path"
}

rollback_changes() {
  local program=""
  local path=""

  if [ "$rollback_in_progress" -eq 1 ]; then
    return
  fi

  rollback_in_progress=1

  warn "Install failed; rolling back changes."

  for ((idx=${#configured_programs[@]} - 1; idx>=0; idx--)); do
    program="${configured_programs[$idx]}"
    stow --dir="$REPO_ROOT" -D -v --target="$HOME" "$program" || true
  done

  if [ -n "$backup_dir" ] && [ -d "$backup_dir" ]; then
    for path in "${restored_paths[@]}"; do
      if [ -e "$backup_dir/$(basename "$path")" ] || [ -L "$backup_dir/$(basename "$path")" ]; then
        mv "$backup_dir/$(basename "$path")" "$path"
        log "Restored $path"
      fi
    done
  fi
}

on_error() {
  local exit_code="$1"

  if [ "$rollback_enabled" -eq 1 ]; then
    rollback_changes
  fi

  exit "$exit_code"
}

trap 'on_error $?' ERR

run_apply() {
  local program=""
  local stow_args=(--dir="$REPO_ROOT" -v -R --target="$HOME")
  for program in "${PROGRAMS[@]}"; do
    configured_programs+=("$program")
    stow "${stow_args[@]}" "$program"
    log "Configured $program"
  done
  rollback_enabled=0
}

run_dry_run() {
  log "Running in dry-run mode"
  run_dependency_checks
  run_stow_preflight
}

selected_shell="$(resolve_selected_shell)"
set_managed_paths "$selected_shell"
log "Selected shell package: $selected_shell"

if [ "$check_only" -eq 1 ]; then
  run_dependency_checks
  run_stow_preflight
  log "Check completed successfully."
  exit 0
fi

if [ "$dry_run" -eq 1 ]; then
  run_dry_run
  log "Dry run completed successfully."
  exit 0
fi

run_dependency_checks
rollback_enabled=1
for path in "${ENTRY_PATHS[@]}"; do
  backup_if_exists "$path"
done

for path in "${LEGACY_PATHS[@]}"; do
  cleanup_legacy_path "$path"
done

run_stow_preflight
run_apply
rollback_enabled=0

if [ -n "$backup_dir" ]; then
  log "Backups stored in $backup_dir"
fi

log "Done!"
