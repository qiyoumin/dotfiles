
"-----------------------------------------------------------------------
" auto-pairs
"-----------------------------------------------------------------------
" default value
let g:AutoPairesFlyMode = 0
let g:AutoPairesShortcutBackInsert = '<M-b>'

"-----------------------------------------------------------------------
" ale
"-----------------------------------------------------------------------
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
let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
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

"-----------------------------------------------------------------------
" airline
"-----------------------------------------------------------------------

"-----------------------------------------------------------------------
" gutentags
"-----------------------------------------------------------------------
" gutentags search project path flag
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

" generating file name
let g:gutentags_ctags_tagfile = '.tags'

" take .tags in ~/.cache/tags
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags

" ctags parameters
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" if ~/.cache/tags doesn't exits, create dir
if !isdirectory(s:vim_tags)
   silent! call mkdir(s:vim_tags, 'p')
endif

"-----------------------------------------------------------------------
" indentLine
"-----------------------------------------------------------------------
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

"-----------------------------------------------------------------------
" signify
"-----------------------------------------------------------------------
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
      \ "sh":1,
      \ "zsh":1,
      \ "zimbu":1,
      \ }

"-----------------------------------------------------------------------
" vim-cpp-enhanced-highlight
"-----------------------------------------------------------------------
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1
let g:cpp_no_function_highlight = 1



