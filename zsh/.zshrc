function git_branch() {
  local branch
  branch="$(git branch 2>/dev/null | sed -n 's/^\* //p')"

  if [ -n "$branch" ]; then
    if [ "$branch" = "(no branch)" ]; then
      branch="($(git rev-parse --short HEAD)...)"
    fi
    printf ' (%s)' "$branch"
  fi
}

autoload -Uz colors && colors
PROMPT='%n@%m %F{cyan}%1~%F{green}$(git_branch)%f
$ '

alias ls='ls --color=auto'
alias ll='ls -lrh'
alias lla='ll -a'

_zshrc_dir="${${(%):-%N}:A:h}"

_zsh_fragments=(
  "$_zshrc_dir/.zshrc.d/oh-my-zsh.zsh"
  "$_zshrc_dir/.zshrc.d/dev-tools.zsh"
  "$_zshrc_dir/.zshrc.d/aliases.zsh"
  "$_zshrc_dir/.zshrc.d/wsl.zsh"
)

for _zsh_fragment in "${_zsh_fragments[@]}"; do
  [ -r "$_zsh_fragment" ] && . "$_zsh_fragment"
done
unset _zsh_fragment _zsh_fragments

if [ -f "$HOME/.zshrc.local" ]; then
  . "$HOME/.zshrc.local"
fi
