
"""""""""""""""
" plug
"""""""""""""""

" call plug#begin('~/.vim/plugged')
call plug#begin()

" a nice statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" insert or delete brackets, parens, quotes in pair.
Plug 'jiangmiao/auto-pairs'

" tags
Plug 'ludovicchabant/vim-gutentags'

" dynamic check syntax
Plug 'dense-analysis/ale'

" display the indention levels
Plug 'Yggdroot/indentLine'

" a tree file explorer
Plug 'preservim/nerdtree'

" show diff of git/svn
Plug 'mhinz/vim-signify'

" enhanced highlight
Plug 'octol/vim-cpp-enhanced-heighlight'

" code-completion
Plug 'ycm-core/YouCompleteMe'

call plug#end()

so ~/.vim/plugins.vim

"""""""""""""""
" setting
"""""""""""""""
" Vim is based on Vi. Setting `nocompatible` switches from the default
" Vi-compatibility mode and enables useful Vim functionality. This
" configuration option turns out not to be necessary for the file named
" '~/.vimrc', because Vim automatically enters nocompatible mode if that file
" is present. But we're including it here just in case this config file is
" loaded some other way (e.g. saved as `foo`, and then Vim started with
" `vim -u foo`).
set nocompatible

" Turn on syntax highlighting.
if has('syntax')
  syntax enable
  syntax on
endif

" Disable the default Vim startup message.
set shortmess+=I

" Show line numbers.
set number

" This enables relative line numbering mode. With both number and
" relativenumber enabled, the current line shows the true line number, while
" all other lines (above and below) are numbered relative to the current line.
" This is useful because you can tell, at a glance, what count is needed to
" jump up or down to a particular line, by {count}k to go up or {count}j to go
" down.
set relativenumber

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2

" makes backspace behave more reasonably, in that you can backspace over anything.
set backspace=indent,eol,start

" By default, Vim doesn't let you hide a buffer (i.e. have a buffer that isn't
" shown in any window) that has unsaved changes. This is to prevent you from "
" forgetting about unsaved changes and then quitting e.g. via `:qa!`. We find
" hidden buffers helpful enough to disable this protection. See `:help hidden`
" for more information on this.
set hidden

" Unbind some useless/annoying default key bindings.
nmap Q <Nop> " 'Q' in normal mode enters Ex mode. You almost never want this.

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=

" Enable mouse support. You should avoid relying on this too much, but it can
" sometimes be convenient.
set mouse=a


" open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright


" show matching braces when text indicator is over them / highlight matching {}()
set showmatch

" show times matching braces
set matchtime=2

" show last line
set display=lastline


" Enable copying from vim to the system-clipboard
set clipboard=unnamedplus " sets the default copy register to be +
" set clipboard=unnamed " sets the default copy register to be *


"""""""""""""""
" indent
"""""""""""""""

" Set shift width to 2 spaces
set shiftwidth=2

" Set tab width to 2 columns
set tabstop=2

" Use space characters instead of tabs, prevent from different tab size with others
set expandtab

" press one <Backspace> removes a tab size, in according with tabstop=2
set softtabstop=2

" Set automatic indentation
set autoindent

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=5

" open c/c++ smart indent optimization
set cindent

" wrap messgaes to 72 columns for git commit messages
" set textwidth=72

"""""""""""""""
" Searching
"""""""""""""""

" This setting makes search case-insensitive when all characters in the string
" being searched are lowercase. However, the search becomes case-sensitive if
" it contains any capital letters. This makes searching more convenient.
set ignorecase
set smartcase

" Enable searching as you type, rather than waiting till you press enter.
set incsearch

" highlight matches
set hlsearch

" Searching 'tags' path
set tags=./.tags;,.tags


"""""""""""""""
" Wildmenu
"""""""""""""""

" Enable auto completion menu after pressing tab
set wildmenu

" Make wildmenu behave like similar to Bash completion
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim
" Wildmenu will ignore files with these extensions
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx



"""""""""""""""""""
" mapping keyboards
"""""""""""""""""""

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




"""""""""""""""""""
" style color
"""""""""""""""""""

" colorscheme (delek, peachpuff, desert, ron)
:colorscheme desert

" style color in tmux
if &term =~ '256color' && $TMUX != ''
  set t_ut=
endif

set listchars=tab:▸\ ,trail:·,extends:>,precedes:<,nbsp:·
if &termencoding ==# 'utf-8' || &encoding ==# 'utf-8'
    set listchars=tab:⇥\ ,trail:·,extends:⇉,precedes:⇇,nbsp:⚭
    set fillchars=vert:╎,fold:·
endif
set list


"""""""""""""""""""
" tabline style
"""""""""""""""""""

set tabline=%!MyTabLine()  " custom tab pages line
function! MyTabLine()
  let s = ''
  " loop through each tab page
  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#' " WildMenu
    else
      let s .= '%#Title#'
    endif
    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T '
    " set page number string
    let s .= i + 1 . ''
    " get buffer names and statuses
    let n = ''  " temp str for buf names
    let m = 0   " &modified counter
    let buflist = tabpagebuflist(i + 1)
    " loop through each buffer in a tab
    for b in buflist
      if getbufvar(b, "&buftype") == 'help'
        " let n .= '[H]' . fnamemodify(bufname(b), ':t:s/.txt$//')
      elseif getbufvar(b, "&buftype") == 'quickfix'
        " let n .= '[Q]'
      elseif getbufvar(b, "&modifiable")
        let n .= fnamemodify(bufname(b), ':t') . ', ' " pathshorten(bufname(b))
      endif
      if getbufvar(b, "&modified")
        let m += 1
      endif
    endfor
    " let n .= fnamemodify(bufname(buflist[tabpagewinnr(i + 1) - 1]), ':t')
    let n = substitute(n, ', $', '', '')
    " add modified label
    if m > 0
      let s .= '+'
      " let s .= '[' . m . '+]'
    endif
    if i + 1 == tabpagenr()
      let s .= ' %#TabLineSel#'
    else
      let s .= ' %#TabLine#'
    endif
    " add buffer names
    if n == ''
      let s.= '[New]'
    else
      let s .= n
    endif
    " switch to no underlining and add final space
    let s .= ' '
  endfor
  let s .= '%#TabLineFill#%T'
  " right-aligned close button
  " if tabpagenr('$') > 1
  "   let s .= '%=%#TabLineFill#%999Xclose'
  " endif
  return s
endfunction

:highlight TabLineFill term=reverse cterm=none ctermfg=246 ctermbg=251

