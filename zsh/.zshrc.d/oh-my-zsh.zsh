# Oh My Zsh setup, enabled only when it is installed on this machine.

export ZSH="${ZSH:-$HOME/.oh-my-zsh}"

if [ ! -r "$ZSH/oh-my-zsh.sh" ]; then
  return
fi

ZSH_THEME="${ZSH_THEME:-apple}"
CASE_SENSITIVE="${CASE_SENSITIVE:-true}"
DISABLE_AUTO_TITLE="${DISABLE_AUTO_TITLE:-true}"

_omz_plugins=(
  git
  z
)

_zsh_custom="${ZSH_CUSTOM:-$ZSH/custom}"
_zsh_completion_dir="$_zsh_custom/plugins/zsh-completions/src"
if [ -d "$_zsh_completion_dir" ]; then
  fpath+=("$_zsh_completion_dir")
  _omz_plugins+=(zsh-completions)
fi

for _plugin in zsh-autosuggestions zsh-syntax-highlighting; do
  if [ -d "$_zsh_custom/plugins/$_plugin" ]; then
    _omz_plugins+=("$_plugin")
  fi
done
unset _plugin

plugins=("${_omz_plugins[@]}")
unset _omz_plugins _zsh_completion_dir _zsh_custom

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="${ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE:-fg=#586e75}"

source "$ZSH/oh-my-zsh.sh"
