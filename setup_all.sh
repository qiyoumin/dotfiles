#!/usr/bin/env bash

set -euo pipefail

PROGRAMS=(bash git vim tmux)
ENTRY_PATHS=(
  "$HOME/.bashrc"
  "$HOME/.gitconfig"
  "$HOME/.vimrc"
  "$HOME/.tmux.conf"
)
LEGACY_PATHS=(
  "$HOME/.vim"
)
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

dry_run=0
for arg in "$@"; do
  case "$arg" in
    --dry-run|-n)
      dry_run=1
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      echo "Usage: $0 [--dry-run]" >&2
      exit 1
      ;;
  esac
done

if ! command -v stow >/dev/null 2>&1; then
  echo "Missing dependency: stow" >&2
  exit 1
fi

backup_dir=""

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
    backup_dir="dotfile_bk_$(date -u +"%Y%m%d%H%M%S")"
    mkdir -p "$backup_dir"
    echo "Created backup directory: $backup_dir"
  fi

  mv "$path" "$backup_dir/"
  echo "Backed up $path"
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

stow_args=(-v -R --target="$HOME")
if [ "$dry_run" -eq 1 ]; then
  stow_args+=(-n)
  echo "Running in dry-run mode"
else
  for path in "${ENTRY_PATHS[@]}"; do
    backup_if_exists "$path"
  done

  for path in "${LEGACY_PATHS[@]}"; do
    cleanup_legacy_path "$path"
  done
fi

for program in "${PROGRAMS[@]}"; do
  stow "${stow_args[@]}" "$program"
  echo "Configured $program"
done

if [ -n "$backup_dir" ]; then
  echo "Backups stored in $backup_dir"
fi

echo "Done!"
