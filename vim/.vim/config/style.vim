
"-----------------------------------------------------------------------
" basic display
"-----------------------------------------------------------------------

" show matching braces when text indicator is over them / highlight matching {}()
set showmatch

" show current mode in command-line.
set showmode
" show already typed keys when more are expected.
set showcmd

" show times matching braces
set matchtime=2

" show as much as possible of the last line
set display=lastline

" deferred drawing (improves performance)
set lazyredraw

" Show line numbers.
set number
set relativenumber

" open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Enable auto completion menu after pressing tab
set wildmenu

" Make wildmenu behave like similar to Bash completion
set wildmode=list:longest

" display cursor line
autocmd BufEnter,WinEnter * set cursorline
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline

" Turn on syntax highlighting.
if has('syntax')
  syntax enable
  syntax on
endif

" show non-printable characters.
set listchars=tab:▸\ ,trail:·,extends:>,precedes:<,nbsp:·
if &termencoding ==# 'utf-8' || &encoding ==# 'utf-8'
    set listchars=tab:⇥\ ,trail:·,extends:⇉,precedes:⇇,nbsp:⚭
    set fillchars=vert:╎,fold:·
endif
set list

"-----------------------------------------------------------------------
" color style
"-----------------------------------------------------------------------

" colorscheme (delek, peachpuff, desert, ron)
:colorscheme desert

"----------------------------------------------------------------------
" change style
"----------------------------------------------------------------------

" modify error markings
" show red or blue underlines of wavy lines
" hi! clear SpellBad
" hi! clear SpellCap
" hi! clear SpellRare
" hi! clear SpellLocal
" if has('gui_running')
" 	hi! SpellBad gui=undercurl guisp=red
" 	hi! SpellCap gui=undercurl guisp=blue
" 	hi! SpellRare gui=undercurl guisp=magenta
" 	hi! SpellRare gui=undercurl guisp=cyan
" else
"  	hi! SpellBad term=standout ctermfg=1 term=underline cterm=underline
"  	hi! SpellCap term=underline cterm=underline
" 	hi! SpellRare term=underline cterm=underline
" 	hi! SpellLocal term=underline cterm=underline
" endif

" remove the white background of the sign column
hi! SignColumn guibg=NONE ctermbg=NONE

" modify the color of line number to light gray
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE
  \ gui=NONE guifg=DarkGrey guibg=NONE

" modify the color of the completion directory
hi! Pmenu guibg=gray guifg=black ctermbg=gray ctermfg=black
hi! PmenuSel guibg=gray guifg=brown ctermbg=brown ctermfg=gray


"-----------------------------------------------------------------------
" tabline style
"-----------------------------------------------------------------------

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

