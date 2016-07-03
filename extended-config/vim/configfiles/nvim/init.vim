"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set expandtab
set shiftwidth=2
set tabstop=2

set autoindent

" Show line numbers.
set number

" " Don't wrap lines.
" set nowratp

set noswapfile
set history=1000

" Make searches case-insensative except when you include uppercase characters.
set ignorecase
set smartcase
" Clear the search buffer when you press ,/
nmap <silent> ,/ :nohlsearch<CR>

" Use vim nav keys to switch tabs.
map  <C-l> :tabn<CR>
map  <C-h> :tabp<CR>

nnoremap ; :
noremap j gj
noremap k gk

" Backspace was acting weirdly without this (at least with the
" vim_configurable nix package).
"
" http://vimdoc.sourceforge.net/htmldoc/options.html#%27backspace%27
set backspace=2

" set mouse=a Allow you to scroll using the mouse.
"
" This needs to be turned to `mouse=` when using Vim over SSH.
" (or when copying out of vim by highlighting with the mouse).
set mouse=

" Selecting text using the vim keys copies it to the clipboard.
set clipboard=unnamed

" Don't create a ~/.vim/.netrwhist file.
let g:netrw_dirhistmax=0

" End-of-line formats tried.
set ffs=unix

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Specific Changes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd! BufWritePost * Neomake

" supertab
let g:SuperTabDefaultCompletionType = '<c-x><c-o>'
if has("gui_running")
  imap <c-space> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
else " no gui
  if has("unix")
    inoremap <Nul> <c-r>=SuperTabAlternateCompletion("\<lt>c-x>\<lt>c-o>")<cr>
  endif
endif

" tabular
let g:haskell_tabular = 1
vmap a= :Tabularize /=<CR>
vmap a; :Tabularize /::<CR>
vmap a- :Tabularize /-><CR>

" ctrlp
let g:ctrlp_map = '<leader>f'
" Show dotfiles.
let g:ctrlp_show_hidden = 1
set wildignore+=*/.git/*,*/.cabal-sandbox/*,*/.stack-work/*,*/dist/*

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetype Specific Changes
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" This is for Go. It doesn't like to be run multiple times so I can't put it
" in ftplugin/go.vim. Since it does some weird stuff I'm leaving it commented
" out by default when not working on Go.
"
" " https://code.google.com/p/go/source/browse/misc/vim/readme.txt
" "
" " Some Linux distributions set filetype in /etc/vimrc.
" " Clear filetype flags before changing runtimepath to force Vim to reload them.
" filetype off
" filetype plugin indent off
" set runtimepath+=$GOROOT/misc/vim
" filetype plugin indent on
" syntax on
" " Optional: Format on save.
" au FileType go au BufWritePre <buffer> Fmt

" Unlike the other syntax files such as 'python.vim', 'text.vim' isn't
" automatically detected so we set it to be detected here.
autocmd BufRead,BufNewFile *.txt set syntax=text

autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown

" See here for a discussion on deterministic JSON with jq:
" https://github.com/stedolan/jq/issues/79
"
" I'm not sure if the current function is deterministic,
" but adding -c (for compact JSON without spaces) would make
" it so.
command JSONFormat :%!jq --indent 2 --sort-keys '.'

" nvie.com/posts/how-i-boosted-my-vim/
"
" Show tab characters, trailing whitespace and invisible spaces.
" Additionally use the # sign to mark lines that extend off-screen.
set list
set listchars=tab:>-,trail:.,extends:#,nbsp:.
" using #ff5faf for hot pink
hi NonText ctermfg=205 guifg=pink
hi SpecialKey ctermfg=205 guifg=pink
" In some files, like HTML and XML files, tabs are fine and
" showing them is really annoying, you can disable them easily
" using an autocmd declaration:
autocmd filetype html,xml set listchars-=tab:>.

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Appearance
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Order also matters for this command because if it comes before the command
" setting the color for tabs to pink, then the native tab color for the
" colorsheme will be overridden.
"
" colo badwolf
" colo eink
" colo moss
" colo mrkn256
" colo zenburn
" colo Tomorrow-Night-Blue
" colo lucius
" colo paintbox
" colo jelleybeans
colo summerfruit256
" colo CodeFactoryv3
" colo Tomorrow

" Change the color of the 'airblade/vim-gitgutter' column.
" highlight SignColumn ctermbg=black

set t_Co=256
