#!/usr/bin/env bash

# PROGRAMS=(bash git tmux vim zsh)
PROGRAMS=(bash git vim tmux)
OLD_DOTFILES="dotfile_bk_$(date -u +"%Y%m%d%H%M%S")"
mkdir $OLD_DOTFILES

function backup_if_exists() {
    if [ -f $1 ];
    then
      mv $1 $OLD_DOTFILES
    fi
    if [ -d $1 ];
    then
      mv $1 $OLD_DOTFILES
    fi
}

# Clean common conflicts
# backup_if_exists ~/.bashrc
backup_if_exists ~/.bashrc
# backup_if_exists ~/.gitconfig
backup_if_exists ~/.gitconfig
# backup_if_exists ~/.vimrc
backup_if_exists ~/.vimrc
# backup_if_exists ~/.tmux.conf
backup_if_exists ~/.tmux.conf

for program in ${PROGRAMS[@]}; do
  stow -v --target=$HOME $program
  echo "Configuring $program"
done

echo "Done!"
