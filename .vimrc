call pathogen#infect()

set nocompatible

set number
set ruler
" set cursorline
syntax on

set guifont=Inconsolata:h14

set encoding=utf-8
set showcmd
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
