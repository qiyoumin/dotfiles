let s:vimrc_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')
execute 'source ' . fnameescape(s:vimrc_dir . '/.vim/init.vim')

" Wrap long lines by default so wide text remains visible without horizontal scrolling.
set wrap

let s:vimrc_local = expand('~/.vimrc.local')
if filereadable(s:vimrc_local)
  execute 'source ' . fnameescape(s:vimrc_local)
endif
