# Common development tool setup.

path=(
  "$HOME/bin"
  "$HOME/.local/bin"
  $path
)

if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

if [[ "$TERM_PROGRAM" == "kiro" ]] && command -v kiro >/dev/null 2>&1; then
  . "$(kiro --locate-shell-integration-path zsh)"
fi
