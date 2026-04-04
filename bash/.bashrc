
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
export PS1='\u@\h \[\033[01;36m\]\W\[\033[01;32m\]$(git_branch)\[\033[00m\] \n\$ '


alias ls='ls --color=auto'
alias ll='ls -lrh'
alias lla='ll -a'

_bashrc_dir="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"

# git autocompletion
if [ -f /usr/share/bash-completion/completions/git ]; then
  . /usr/share/bash-completion/completions/git
fi


# WSL-specific shell adjustments live in a dedicated file.
if grep -qi microsoft /proc/sys/kernel/osrelease 2>/dev/null; then
  if [ -f "${_bashrc_dir}/.bashrc.d/wsl.bashrc" ]; then
    . "${_bashrc_dir}/.bashrc.d/wsl.bashrc"
  fi
fi
