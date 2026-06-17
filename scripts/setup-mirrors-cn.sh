#!/usr/bin/env bash

set -euo pipefail

configure_apt=0
configure_npm=0
configure_pip=0
configure_brew=0
dry_run=0

log() {
  echo "$*"
}

run_cmd() {
  if [ "$dry_run" -eq 1 ]; then
    printf '[dry-run] '
    printf '%q ' "$@"
    printf '\n'
    return
  fi

  "$@"
}

usage() {
  cat <<'EOF'
Usage: ./scripts/setup-mirrors-cn.sh [--apt] [--npm] [--pip] [--brew] [--all] [--dry-run]

Options:
  --apt      Configure the Ubuntu APT mirror.
  --npm      Configure the npm registry mirror.
  --pip      Configure the pip mirror.
  --brew     Configure Homebrew bottle and API mirrors.
  --all      Configure APT, npm, pip, and Homebrew.
  --dry-run  Print actions without making changes.
  --help     Show this help message.
EOF
}

require_command() {
  local command_name="$1"

  if ! command -v "$command_name" >/dev/null 2>&1; then
    echo "Missing required command: $command_name" >&2
    exit 1
  fi
}

ensure_apt_supported() {
  if [ ! -r /etc/os-release ]; then
    echo "APT mirror setup requires /etc/os-release." >&2
    exit 1
  fi

  # shellcheck disable=SC1091
  . /etc/os-release

  case "${ID:-}" in
    ubuntu|debian)
      ;;
    *)
      echo "APT mirror setup is only supported on Debian or Ubuntu." >&2
      exit 1
      ;;
  esac
}

configure_apt_mirror() {
  local codename=""
  local sources_content=""

  log "Configuring the Ubuntu APT mirror."
  require_command sudo
  require_command apt
  require_command lsb_release
  ensure_apt_supported

  codename="$(lsb_release -cs)"
  sources_content="$(cat <<EOF
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${codename} main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${codename}-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${codename}-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${codename}-security main restricted universe multiverse
EOF
)"

  run_cmd sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

  if [ "$dry_run" -eq 1 ]; then
    printf '[dry-run] write /etc/apt/sources.list with:\n%s\n' "$sources_content"
  else
    printf '%s\n' "$sources_content" | sudo tee /etc/apt/sources.list >/dev/null
  fi

  run_cmd sudo apt update
}

configure_npm_mirror() {
  log "Configuring the npm registry mirror."
  require_command npm
  run_cmd npm config set registry https://registry.npmmirror.com
}

configure_pip_mirror() {
  local pip_config_dir="$HOME/.pip"
  local pip_config_path="$pip_config_dir/pip.conf"
  local pip_config_content=""

  log "Configuring the pip mirror."
  pip_config_content="$(cat <<'EOF'
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
trusted-host = pypi.tuna.tsinghua.edu.cn
EOF
)"

  run_cmd mkdir -p "$pip_config_dir"

  if [ "$dry_run" -eq 1 ]; then
    printf '[dry-run] write %s with:\n%s\n' "$pip_config_path" "$pip_config_content"
  else
    printf '%s\n' "$pip_config_content" > "$pip_config_path"
  fi
}

homebrew_env_path() {
  if [ -n "${XDG_CONFIG_HOME:-}" ]; then
    printf '%s\n' "$XDG_CONFIG_HOME/homebrew/brew.env"
  else
    printf '%s\n' "$HOME/.homebrew/brew.env"
  fi
}

set_homebrew_env_var() {
  local env_path="$1"
  local key="$2"
  local value="$3"
  local env_dir=""
  local temp_path=""

  if [ "$dry_run" -eq 1 ]; then
    printf '[dry-run] set %s=%s in %s\n' "$key" "$value" "$env_path"
    return
  fi

  env_dir="$(dirname "$env_path")"
  mkdir -p "$env_dir"
  temp_path="$(mktemp)"

  if [ -f "$env_path" ]; then
    grep -v "^${key}=" "$env_path" > "$temp_path"
  fi

  printf '%s=%s\n' "$key" "$value" >> "$temp_path"
  mv "$temp_path" "$env_path"
}

configure_brew_mirror() {
  local env_path=""

  log "Configuring the Homebrew mirror."
  env_path="$(homebrew_env_path)"
  set_homebrew_env_var "$env_path" HOMEBREW_API_DOMAIN https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api
  set_homebrew_env_var "$env_path" HOMEBREW_BOTTLE_DOMAIN https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --apt)
      configure_apt=1
      shift
      ;;
    --npm)
      configure_npm=1
      shift
      ;;
    --pip)
      configure_pip=1
      shift
      ;;
    --brew)
      configure_brew=1
      shift
      ;;
    --all)
      configure_apt=1
      configure_npm=1
      configure_pip=1
      configure_brew=1
      shift
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    --help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [ "$configure_apt" -eq 0 ] && [ "$configure_npm" -eq 0 ] && [ "$configure_pip" -eq 0 ] && [ "$configure_brew" -eq 0 ]; then
  echo "Choose at least one target: --apt, --npm, --pip, --brew, or --all." >&2
  usage >&2
  exit 1
fi

if [ "$configure_apt" -eq 1 ]; then
  configure_apt_mirror
fi

if [ "$configure_npm" -eq 1 ]; then
  configure_npm_mirror
fi

if [ "$configure_pip" -eq 1 ]; then
  configure_pip_mirror
fi

if [ "$configure_brew" -eq 1 ]; then
  configure_brew_mirror
fi

log "Mirror setup completed."
