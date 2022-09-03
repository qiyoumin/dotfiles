
"-----------------------------------------------------------------------
" prevent the background color of vim under TMUX from displaying abnormally
"-----------------------------------------------------------------------
if &term =~ '256color' && $TMUX != ''
  set t_ut=
endif

