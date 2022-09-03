
let g:mapleader = '\'

" quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Automatically closing braces
" inoremap {<CR> {<CR>}<Esc>ko<tab>
" inoremap ( ()<Esc>ha
" inoremap [ []<Esc>ha
" inoremap " ""<Esc>ha
" inoremap ' ''<Esc>ha
" inoremap ` ``<Esc>ha

" mappings for managing tabs
" map <leader>tn :tabnew<cr>
" map <leader>to :tabOnly<cr>
" map <leader>tc :tabclose<cr>
" map <leader>tm :tabmove
" map <leader>t<leader> :tabnext

" add new blank line
nnoremap [<space>  :<c-u>put =repeat(nr2char(10), v:count1)<cr>
nnoremap ]<space>  :<c-u>put! =repeat(nr2char(10), v:count1)<cr>'[

