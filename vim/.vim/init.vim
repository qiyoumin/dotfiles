
" prevent duplicate loading
if get(s:, 'loaded', 0) != 0
  finish
else
  let s:loaded = 1
endif

" get current directory
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" load file defining a command
command! -nargs=1 LoadScript exec 'so '.s:home.'/'.'<args>'

" add init.vim directory to runtimePath
exec 'set rtp+='.s:home

" add ~/.vim to runtimePath
set rtp+=~/.vim

"-----------------------------------------------------------------------
" load modules
"-----------------------------------------------------------------------

" load base config
LoadScript config/base.vim

" load extension config
LoadScript config/config.vim

" set tabe size
LoadScript config/tabesize.vim

" set keymap
LoadScript config/keymaps.vim

" load style
LoadScript config/style.vim

" load plug config
LoadScript config/plug.vim

