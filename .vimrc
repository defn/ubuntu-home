let g:go_version_warning = 0

let g:slime_target = "tmux"

let g:slime_default_config = {"socket_name": split($TMUX, ",")[0], "target_pane": "%0"}

" source junas
source ~/.vim/junas.vimrc

let cue_scheme=$CUE_SCHEME

if cue_scheme == 'slight'
  " use the Solarized color scheme for light
  colorscheme solarized
  set background=light
else
  " use the xoria256 color scheme for dark
  colorscheme xoria256
  hi Folded  ctermfg=180 guifg=#dfaf87 ctermbg=234 guibg=#1c1c1c
  hi NonText ctermfg=252 guifg=#d0d0d0 ctermbg=234 guibg=#1c1c1c cterm=none gui=none
endif

set shiftround smarttab
set autoindent smartindent
set showmatch

set hidden
set nowrap
set nonumber

set history=1000
set undolevels=1000
set title
set visualbell
set noerrorbells
set t_vb=

set scrolloff=3
set nojoinspaces

set nobackup
set noswapfile

set diffopt+=iwhite
set diffexpr="-w -b -B"

set guioptions=

au BufRead,BufNewFile *.md set filetype=markdown
let g:vim_markdown_folding_disabled = 1

imap ww <Esc>
