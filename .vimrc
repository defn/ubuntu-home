" source junas
source ~/.vim/junas.vimrc

" let g:sexp_enable_insert_mode_mappings = 0

let maplocalleader = "\\"

nmap <C-h> <M-h>
nmap <C-j> <M-j>
nmap <C-k> <M-k>
nmap <C-l> <M-l>
nmap <C-y> cseb
nmap <C-u> <(
nmap <C-i> >(
nmap <C-o> <)
nmap <C-p> >)

nmap <C-n> <I
nmap <C-m> >I

map cpp <C-c><C-c>

function! g:FuckThatMatchParen ()
  if exists(":NoMatchParen")
    :NoMatchParen
  endif
endfunction

augroup plugin_initialize
  autocmd!
  autocmd VimEnter * call FuckThatMatchParen()
augroup END

