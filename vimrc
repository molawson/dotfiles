" Inspiration (and much of the actual code) from Gary Bernhardt's dotfiles (https://github.com/garybernhardt/dotfiles)

call pathogen#infect()

set nocompatible


" Store all .swp files in a common location
set directory=$HOME/.vim/tmp//,.


" Remap leader key to ,
let mapleader=","


" Layout
set relativenumber
set ruler
set showcmd
set laststatus=2
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

" Wrapping and indentation
set wrap
set scrolloff=4
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set backspace=indent,eol,start
filetype plugin indent on

" Display
syntax on
set guifont=Menlo:h12
set encoding=utf-8
set background=dark
colorscheme Tomorrow-Night
" set background=light
" colorscheme Tomorrow
set list listchars=tab:»·,trail:·

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase

" Search results highlighted with underline
highlight Search ctermbg=None ctermfg=None cterm=underline

" Clear the search buffer when hitting return
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()

" CtrlP
let g:ctrlp_match_window = 'order:ttb,max:20'
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_use_caching = 0

" Bash style tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*

au! BufRead,BufNewFile *.pp setfiletype ruby

" Smart, multipurpose tab key - insert tab or autocomplete
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>


" Rename current file
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':Move ' . new_name
    endif
endfunction


"""""""""""""""
" RAILS ROUTES
"""""""""""""""

function! ShowRoutes()
  " Requires 'scratch' plugin
  :topleft 100 :split __Routes__
  " Make sure Vim doesn't write __Routes__ as a file
  :set buftype=nofile
  " Delete everything
  :normal 1GdG
  " Put routes output in buffer
  if filereadable("Gemfile")
    :0r! bundle exec rake -s routes
  else
    :0r! rake -s routes
  end
  " Size window to number of lines (1 plus rake output length)
  :exec ":normal " . line("$") . "_ "
  " Move cursor to bottom
  :normal 1GG
  " Delete empty trailing line
  :normal dd
endfunction


""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
""""""""""""""""""""""""""""""""""""""""""

function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, 'spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1
  let in_engine = match(current_file, '^engines/') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, 'app/', '', '')
    end
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    if in_engine
      let new_file = substitute(new_file, '^engines/\([^/]\+\)/', 'engines/\1/spec/', '')
    else
      let new_file = 'spec/' . new_file
    end
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, 'spec/', '', '')
    if in_app
      if in_engine
        let new_file = substitute(new_file, '^engines/\([^/]\+\)/', 'engines/\1/app/', '')
      else
        let new_file = 'app/' . new_file
      end
    end
  endif
  return new_file
endfunction


""""""""""""""""
" RUNNING TESTS
""""""""""""""""

function! RunTestFile(...)
  if a:0
    let command_prefix = a:1
    let command_suffix = a:2
  else
    let command_prefix = ""
    let command_suffix = ""
  endif

  " Run the tests for the previously-marked file.
  let in_test_file = match(expand("%"), '\(_spec.rb\)$') != -1
  if in_test_file
    call SetTestFile()
  elseif !exists("t:mol_test_file")
    return
  end
  call RunTests(command_prefix . t:mol_test_file . command_suffix)
endfunction

function! RunNearestTest()
  let spec_line_number = line('.')
  " call RunTestFile("-b ", ":" . spec_line_number)
  call RunTestFile("", ":" . spec_line_number)
endfunction

function! SetTestFile()
  " Set the spec file that tests will be run for.
  let t:mol_test_file=@%
endfunction

function! RunTests(filename)
  " Write the file and run tests for the given filename
  :w
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
  if filereadable("script/test")
    exec ":!script/test " . a:filename
  elseif getfsize(".zeus.sock") >= 0
    exec ":!zeus test " . a:filename
  elseif filereadable("Gemfile")
    exec ":!bundle exec rspec --color " . a:filename
  else
    exec ":!rspec --color " . a:filename
  end
endfunction


"""""""""""""""""""
" LEADER SHORTCUTS
"""""""""""""""""""

" CtrlP
map <leader>f :CtrlP<cr>
map <leader>b :CtrlPBuffer<cr>
map <leader>c :CtrlPTag<cr>
map <leader>r :CtrlPMRU<cr>

" Rails
map <leader>gg :topleft 100 :split Gemfile<cr>
map <leader>gr :topleft :split config/routes.rb<cr>
map <leader>gR :call ShowRoutes()<cr>
map <leader>gs :CtrlP app/assets/stylesheets<cr>
map <leader>gj :CtrlP app/assets/javascripts<cr>
map <leader>gv :CtrlP app/views<cr>
map <leader>gc :CtrlP app/controllers<cr>
map <leader>gm :CtrlP app/models<cr>
map <leader>gh :CtrlP app/helpers<cr>
map <leader>gl :CtrlP lib<cr>
map <leader>gp :CtrlP public<cr>
map <leader>gt :CtrlP spec<cr>

" Tests
nnoremap <leader>. :call OpenTestAlternate()<cr>
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>s :call SetTestFile()<cr>

" The Silver Searcher (Ag)
map <leader>ag :Ag! 
map <leader>ac :Ag! <cword><cr>
map <leader>as :AgFromSearch!<cr>

" Copy to and paste from system clipboard
map <leader>p "*p<cr>
map <leader>P "*P<cr>
map <leader>y "*y<cr>

" Delete to black hole register
map <leader>d "_d<cr>
map <leader>D "_dd<cr>

" Rename current file
map <leader>n :call RenameFile()<cr>

" Open .vimrc in a new tab
map <leader>v :tabe ~/.vimrc<cr>

imap <c-l> <space>=><space>


" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l


augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  autocmd FileType cf set commentstring=<!---\ %s\ --->

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()
augroup END


" Automatic split resizing
set winwidth=60
set winminwidth=60
set winwidth=160
set winheight=10
set winminheight=10
set winheight=999
