
"-----------------------------------------------------------------------
" basic
"-----------------------------------------------------------------------
set nocompatible

" Disable the default Vim startup message.
set shortmess+=I

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


" Enable copying from vim to the system-clipboard
" set clipboard=unnamedplus " sets the default copy register to be +
" set clipboard=unnamed " sets the default copy register to be *

" :vnoremap <C-c> "*y

" open function key timeout detection
set ttimeout
" function key timeout detection 50 ms
set ttimeoutlen=50
" show ruler position
set ruler

"-----------------------------------------------------------------------
" Searching
"-----------------------------------------------------------------------

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

"-----------------------------------------------------------------------
" encode
"-----------------------------------------------------------------------
if has('multi_byte')
  " internal working encode
  set encoding=utf-8

  " file default encoding
  set fileencoding=utf-8

  " automatically try the following encodings when opening a file
  set fileencodings=ucs-bom,utf-8,gbk,gb18030,big5,euc-jp,latin1
endif

"-----------------------------------------------------------------------
" allow vim's built-in scripts to automatically set indentation based
" on file type, etc
"-----------------------------------------------------------------------
if has('autocmd')
  filetype plugin indent on
endif

"-----------------------------------------------------------------------
" ignore the following extensions for file search and completion
"-----------------------------------------------------------------------
set suffixes=.bak,~,.o,.h,.info,.swp,.obj,.pyc,.pyo,.egg-info,.class

set wildignore=*.o,*.obj,*~,*.exe,*.a,*.pdb,*.lib "stuff to ignore when tab completing
set wildignore+=*.so,*.dll,*.swp,*.egg,*.jar,*.class,*.pyc,*.pyo,*.bin,*.dex
set wildignore+=*.zip,*.7z,*.rar,*.gz,*.tar,*.gzip,*.bz2,*.tgz,*.xz    " MacOSX/Linux
set wildignore+=*DS_Store*,*.ipch
set wildignore+=*.gem
set wildignore+=*.png,*.jpg,*.gif,*.bmp,*.tga,*.pcx,*.ppm,*.img,*.iso
set wildignore+=*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,*/.rbenv/**
set wildignore+=*/.nx/**,*.app,*.git,.git
set wildignore+=*.wav,*.mp3,*.ogg,*.pcm
set wildignore+=*.mht,*.suo,*.sdf,*.jnlp
set wildignore+=*.chm,*.epub,*.pdf,*.mobi,*.ttf
set wildignore+=*.mp4,*.avi,*.flv,*.mov,*.mkv,*.swf,*.swc
set wildignore+=*.ppt,*.pptx,*.docx,*.xlt,*.xls,*.xlsx,*.odt,*.wps
set wildignore+=*.msi,*.crx,*.deb,*.vfd,*.apk,*.ipa,*.bin,*.msu
set wildignore+=*.gba,*.sfc,*.078,*.nds,*.smd,*.smc
set wildignore+=*.linux2,*.win32,*.darwin,*.freebsd,*.linux,*.android

"-----------------------------------------------------------------------
" temporary files in vim
"-----------------------------------------------------------------------

" " Put all temporary files under the same directory.
" if !isdirectory($HOME.'/.vim/vim-files') && exists('*mkdir')
"   call mkdir($HOME.'/.vim/vim-files')
" endif
" " backup original file
" set backup
" set backupdir   =$HOME/.vim/vim-files/backup//
" set backupext   =-vimbackup
" set backupskip  =
" " swap file
" " don't recommend in multi-user system, because no warning if multi persons edit at the same time
" " set directory   =$HOME/.vim/files/swap//
" " set updatecount =100
" " undo file
" set undofile
" set undodir     =$HOME/.vim/vim-files/undo//
" " viminfo file(other info)
" set viminfo     ='100,n$HOME/.vim/vim-files/info/viminfo

