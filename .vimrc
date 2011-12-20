call pathogen#infect()

set nocompatible

" Layout
set number
set ruler
set showcmd
set laststatus=2
syntax on

set guifont=Inconsolata:h14

set encoding=utf-8
filetype plugin indent on

" Wrapping and indentation
set wrap
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set backspace=indent,eol,start

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase
:noremap <CR> :nohlsearch<cr>

" Bash style tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*

if has("gui_running")
  :colorscheme desert
  :set go-=T
end

" Remap leader key to ,
let mapleader=","

" CommandT
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
map <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>
let g:CommandTMaxHeight=20

" Paste from system clipboard
map <leader>p "*p<cr>
map <leader>P "*P<cr>

" Search results highlighted with underline
highlight Search ctermbg=None ctermfg=None cterm=underline

" Automatic split resizing
set winwidth=60
set winminwidth=60
set winwidth=160
set winheight=10
set winminheight=10
set winheight=999
