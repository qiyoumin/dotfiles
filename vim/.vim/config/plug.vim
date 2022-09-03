
" plugins group
if !exists('g:bundle_group')
  let g:bundle_group = ['basic', 'filetypes']
  let g:bundle_group += ['tags', 'airline', 'ale']
endif

"-----------------------------------------------------------------------
" plugInstall start
"-----------------------------------------------------------------------

" call plug#begin('~/.vim/plugged')
call plug#begin()

"-----------------------------------------------------------------------
" default plugin
"-----------------------------------------------------------------------

" enhanced diff supporting histogram / patience
Plug 'chrisbra/vim-diff-enhanced'

" display the indention levels
Plug 'Yggdroot/indentLine'

let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#A4E57E'
let g:indentLine_color_tty_light = 7 " (default: 4)
let g:indentLine_color_dark = 1 " (default: 2)
" let g:indentLine_bgcolor_term = 202
" let g:indentLine_bgcolor_gui = '#FF5F00'
let g:indentLine_char = '┆'
" let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_enabled = 1
let g:markdown_syntax_conceal = 0

" insert or delete brackets, parens, quotes in pair.
Plug 'jiangmiao/auto-pairs'

" default value
let g:AutoPairesFlyMode = 0
let g:AutoPairesShortcutBackInsert = '<M-b>'


"-----------------------------------------------------------------------
" basic plugin
"-----------------------------------------------------------------------
if index(g:bundle_group, 'basic') >= 0

  " many colorschemes
  Plug 'flazz/vim-colorschemes'

  " git support
  Plug 'tpope/vim-fugitive'
  " show diff of git/svn in side symbol bar
  Plug 'mhinz/vim-signify'

  let g:signify_vcs_list = ['git', 'svn']
  let g:signify_sign_add               = '+'
  let g:signify_sign_delete            = '_'
  let g:signify_sign_delete_first_line = '‾'
  let g:signify_sign_change            = '~'
  let g:signify_sign_changedelete      = g:signify_sign_change

  " diff algorithm: histogram
  let g:signify_vcs_cmds = {
      \ 'git': 'git diff --no-color --diff-algorithm=histogram --no-ext-diff -U0 -- %f',
      \}

endif


"-----------------------------------------------------------------------
" tag plugin
"-----------------------------------------------------------------------
if index(g:bundle_group, 'tags') >= 0

  " automatic generating tags
  Plug 'ludovicchabant/vim-gutentags'

  " gutentags search project path flag
  let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

  " generating file name
  let g:gutentags_ctags_tagfile = '.tags'

  " take .tags in ~/.cache/tags
  let s:vim_tags = expand('~/.cache/tags')
  let g:gutentags_cache_dir = s:vim_tags

  " forbidden automatic generating
  let g:gutentags_modules = []

  " if has ctags, automatically generate ctags file
  if executable('ctags')
    let g:gutentags_modules += ['ctags']
  endif
  " if has gtags, automatically generate gtags db
  " if executable('gtags') && executable('gtags-cscope')
  "   let g:gutentags_modules += ['gtags_cscope']
  " endif

  " ctags parameters
  let g:gutentags_ctags_extra_args = []
  let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
  let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
  let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

  " if don't use universal-ctags, please comment
  let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

  " forbidden gutentags automatically link gtags db
  " let g:gutentags_auto_add_gtags_cscope = 0

  " if ~/.cache/tags doesn't exits, create dir
  if !isdirectory(s:vim_tags)
     silent! call mkdir(s:vim_tags, 'p')
  endif

endif


"-----------------------------------------------------------------------
" file type expanding
"-----------------------------------------------------------------------
if index(g:bundle_group, 'filetypes') >= 0

  " c++ enhanced highlight
  Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }

  " extra syntax file
  Plug 'justinmk/vim-syntax-extra', { 'for': ['c', 'bison', 'flex', 'cpp'] }

  let g:cpp_class_scope_highlight = 1
  let g:cpp_member_variable_highlight = 1
  let g:cpp_class_decl_highlight = 1
  let g:cpp_posix_standard = 1
  let g:cpp_experimental_template_highlight = 1
  let g:cpp_concepts_highlight = 1
  let g:cpp_no_function_highlight = 1

endif


"-----------------------------------------------------------------------
" ale: dynamic syntax checking
"-----------------------------------------------------------------------
if index(g:bundle_group, 'ale') >= 0

  " dynamic check syntax
  Plug 'dense-analysis/ale'

  let g:ale_completion_delay = 500
  let g:ale_echo_delay = 20
  let g:ale_lint_delay = 500
  let g:ale_echo_msg_format = '[%linter%] %code: %%s'
  let g:ale_lint_on_text_changed = 'normal'
  let g:ale_lint_on_insert_leave = 1
  let g:airline#extensions#ale#enabled = 1

  let g:ale_sign_error = '>>'
  let g:ale_sign_warning = '--'

  let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
  let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++17'
  let g:ale_c_cppcheck_options = ''
  let g:ale_cpp_cppcheck_options = ''

  " linter
  let g:ale_linters = {
                        \ 'c': ['gcc', 'cppcheck'], 
                        \ 'cpp': ['gcc', 'cppcheck'], 
                        \ }

  " hi! clear SpellBad
  " hi! clear SpellCap
  " hi! clear SpellRare
  " hi! SpellBad gui=undercurl guisp=red
  " hi! SpellCap gui=undercurl guisp=blue
  " hi! SpellRare gui=undercurl guisp=magenta

endif


"-----------------------------------------------------------------------
" airline
"-----------------------------------------------------------------------
if index(g:bundle_group, 'airline') >= 0

  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'

" if !exists('g:airline_symbols')
"   let g:airline_symbols = {}
" endif
" let g:airline_left_sep = '▶'
" let g:airline_left_alt_sep = '❯'
" let g:airline_right_sep = '◀'
" let g:airline_right_alt_sep = '❮'
" let g:airline_symbols.linenr = '¶'
" let g:airline_symbols.branch = '⎇'

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'

  " let g:airline_left_sep = ''
  " let g:airline_left_alt_sep = ''
  " let g:airline_right_sep = ''
  " let g:airline_right_alt_sep = ''
  " let g:airline_powerline_fonts = 0
  " let g:airline_exclude_preview = 1
  " let g:airline_section_b = '%n'
  " let g:airline_theme='deus'
  " let g:airline#extensions#branch#enabled = 0
  " let g:airline#extensions#syntastic#enabled = 0
  " let g:airline#extensions#fugitiveline#enabled = 0
  " let g:airline#extensions#csv#enabled = 0
  " let g:airline#extensions#vimagit#enabled = 0

endif


"-----------------------------------------------------------------------
" plugInstall end
"-----------------------------------------------------------------------

" code-completion
Plug 'ycm-core/YouCompleteMe'

call plug#end()


"-----------------------------------------------------------------------
" YouCompleteMe
"-----------------------------------------------------------------------


let g:ycm_add_preview_to_completeopt = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_server_log_level = 'info'
let g:ycm_min_num_identifier_candidate_chars = 3
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings=1
let g:ycm_key_invoke_completion = '<c-z>'
set completeopt=menu,menuone

" noremap <c-z> <NOP>

" highlight PMenu ctermfg=0 ctermbg=242 guifg=black guibg=darkgrey
" highlight PMenuSel ctermfg=242 ctermbg=8 guifg=darkgrey guibg=black

let g:ycm_semantic_triggers =  {
      \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{3}'],
      \ 'cs,lua,javascript': ['re!\w{2}'],
      \ }

let g:ycm_filetype_whitelist = {
      \ "c":1,
      \ "cpp":1,
      \ "objc":1,
      \ "objcpp":1,
      \ "python":1,
      \ "java":1,
      \ "javascript":1,
      \ "coffee":1,
      \ "vim":1,
      \ "go":1,
      \ "cs":1,
      \ "lua":1,
      \ "perl":1,
      \ "perl6":1,
      \ "php":1,
      \ "ruby":1,
      \ "rust":1,
      \ "erlang":1,
      \ "asm":1,
      \ "nasm":1,
      \ "masm":1,
      \ "tasm":1,
      \ "asm68k":1,
      \ "asmh8300":1,
      \ "asciidoc":1,
      \ "basic":1,
      \ "vb":1,
      \ "make":1,
      \ "cmake":1,
      \ "html":1,
      \ "css":1,
      \ "less":1,
      \ "json":1,
      \ "cson":1,
      \ "typedscript":1,
      \ "haskell":1,
      \ "lhaskell":1,
      \ "lisp":1,
      \ "scheme":1,
      \ "sdl":1,
      \ "sh":1,
      \ "zsh":1,
      \ "bash":1,
      \ "man":1,
      \ "markdown":1,
      \ "matlab":1,
      \ "maxima":1,
      \ "dosini":1,
      \ "conf":1,
      \ "config":1,
      \ "zimbu":1,
      \ "ps1":1,
      \ }

