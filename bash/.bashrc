
# set the keybindings to vi mode.
set -o vi
bind -m vi-command 'Control-l: clear-screen'
bind -m vi-insert  'Control-l: clear-screen'

# git branch display
function git_branch {
    branch="`git branch 2>/dev/null | grep "^\*" | sed -e "s/^\*\ //"`"
    if [ "${branch}" != "" ];then
        if [ "${branch}" = "(no branch)" ];then
            branch="(`git rev-parse --short HEAD`...)"
        fi
        echo " ($branch)"
    fi
}
export PS1='\u@\h \[\033[01;36m\]\w\[\033[01;32m\]$(git_branch)\[\033[00m\] \n\$ '


alias ls='ls --color=auto'
alias ll='ls -lrh'
alias lla='ll -a'

_bashrc_dir="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"

# git autocompletion
if [ -f /usr/share/bash-completion/completions/git ]; then
  . /usr/share/bash-completion/completions/git
fi


for _bashrc_fragment in "${_bashrc_dir}"/.bashrc.d/*.bashrc; do
  if [ -f "$_bashrc_fragment" ]; then
    . "$_bashrc_fragment"
  fi
done
unset _bashrc_fragment

if [ -f "$HOME/.bashrc.local" ]; then
  . "$HOME/.bashrc.local"
fi
