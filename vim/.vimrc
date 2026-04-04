let s:vimrc_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
execute 'source ' . fnameescape(s:vimrc_dir . '/.vim/init.vim')
