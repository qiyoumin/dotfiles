
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

# git autocompletion
if [ -f ~/.git-completion.bash ]; then 
. ~/.git-completion.bash 
fi 
