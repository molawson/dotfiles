" Inspiration (and much of the actual code) from Gary Bernhardt's dotfiles (https://github.com/garybernhardt/dotfiles)

call plug#begin('~/.vim/plugged')
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'mileszs/ack.vim'
Plug 'kien/ctrlp.vim'
Plug 'JazzCore/ctrlp-cmatcher'
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-scripts/matchit.zip'
Plug 'tomtom/tlib_vim'
Plug 'ervandew/supertab'
Plug 'edkolev/tmuxline.vim'
Plug 'tpope/vim-abolish'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Townk/vim-autoclose'
Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-commentary'
Plug 'elixir-lang/vim-elixir'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'vim-ruby/vim-ruby'
Plug 'ecomba/vim-ruby-refactoring'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-surround'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'skalnik/vim-vroom'
Plug 'dense-analysis/ale'
Plug 'slim-template/vim-slim'
Plug 'fatih/vim-go'
Plug 'rust-lang/rust.vim'
call plug#end()

set nocompatible


" Store all .swp files in a common location
set directory^=$HOME/.vim/tmp//

" Add .git/tags for ctag support (vim-fugitive used to do this)
set tags^=./.git/tags;

" Remap leader key to ,
let mapleader=","

" Layout
set number
set relativenumber
set ruler
set showcmd
set laststatus=2
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
set cc=100

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

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

let g:airline_section_b = ''
let g:airline_section_y = ''
let g:airline_section_z = airline#section#create(['linenr',  ':%3v'])

let g:tmuxline_preset = {
      \ 'a': '#S',
      \ 'b': ' #(cd #{pane_current_path};git ref)',
      \ 'win': '#I #W#F',
      \ 'cwin': '#I #W',
      \ 'y': '%a %b %d - %-l:%M %p',
      \ 'z': '#(battery_percentage)'}


" Display
syntax on
set guifont=Menlo\ for\ Powerline:h15
set encoding=utf-8
colorscheme Tomorrow-Night
" set background=light
" colorscheme solarized
set list listchars=tab:»·,trail:·
set cursorline

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
let g:ctrlp_match_func = { 'match' : 'matcher#cmatch' }
let g:ctrlp_match_window = 'order:ttb,max:20'
let g:ctrlp_user_command = 'ag %s -lU --hidden --nocolor -g ""'
let g:ctrlp_show_hidden = 1
let g:ctrlp_use_caching = 0

let g:vroom_test_unit_command = 'bin/rails test '
let g:vroom_use_bundle_exec = 1
let g:vroom_use_terminal = 1

let g:jsx_ext_required = 0

if executable('ag')
  let g:ackprg = 'ag -F --vimgrep'
endif

" Keep JS snippets out of html files
" let g:snipMate = {}
" let g:snipMate.scope_aliases = {}
" let g:snipMate.scope_aliases['html'] = ''

" Bash style tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*

" Markdown code block syntax highlighting
let g:markdown_fenced_languages=['ruby', 'eruby', 'javascript', 'html', 'sh']

au! BufRead,BufNewFile *.pp setfiletype ruby


" TODO: come up with a decent way to do this with ale
" " Let Rubocop auto correct style issues
" function! AutoCop()
"   let l:extra_args = g:vimrubocop_extra_args
"   let l:filename = @%
"   let l:rubocop_cmd = g:vimrubocop_rubocop_cmd
"   let l:rubocop_opts = ' -a '.l:extra_args.''
"   if g:vimrubocop_config != ''
"     let l:rubocop_opts = ' '.l:rubocop_opts.' --config '.g:vimrubocop_config
"   endif
"   " go ahead and save the current file
"   write
"   " let rubocop do its thing
"   call system(l:rubocop_cmd.l:rubocop_opts.' '.l:filename)
"   " refresh the buffer
"   edit
" endfunction

" Rename current file
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':Move ' . new_name
    endif
endfunction

" Create parent directories and write
function! WriteCreatingDirs()
    call system('mkdir -p '.expand('%:h'))
    write
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
  let using_rspec = !isdirectory('test')
  let in_test = match(current_file, 'spec/') != -1 || match(current_file, 'test/') != -1
  let going_to_test = !in_test
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1 || match(current_file, '\<presenters\>') != -1 || match(current_file, '\<services\>') != -1 || match(current_file, '\<jobs\>') != -1 || match(current_file, '\<mailers\>') != -1 || match(current_file, '\<csvs\>') != -1 || match(current_file, '\<types\>') != -1 || match(current_file, '\<policies\>') != -1
  let in_gem = !empty(glob('*.gemspec'))
  if going_to_test
    if in_app
      let new_file = substitute(new_file, 'app/', '', '')
    elseif in_gem
      let new_file = substitute(new_file, 'lib/', '', '')
    end
    if using_rspec
      let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
      let new_file = 'spec/' . new_file
    else
      let new_file = substitute(new_file, '\.rb$', '_test.rb', '')
      let new_file = 'test/' . new_file
    end
  else
    if using_rspec
      let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
      let new_file = substitute(new_file, 'spec/', '', '')
    else
      let new_file = substitute(new_file, '_test\.rb$', '.rb', '')
      let new_file = substitute(new_file, 'test/', '', '')
    end
    if in_app
      let new_file = 'app/' . new_file
    elseif in_gem
      let new_file = 'lib/' . new_file
    end
  endif
  return new_file
endfunction


"""""""""""""""""""
" RUBY REFACTORING
"""""""""""""""""""

function! PromoteToLet()
  normal 0
  if empty(matchstr(getline("."), "=")) == 1
    echo "Can't find an assignment"
    return
  end
  normal! dd
  exec "?^\\s*\\<\\(describe\\|context\\)\\>"
  normal! $p
  exec 's/\v([a-z_][a-zA-Z0-9_]*) \= (.+)/let(:\1) { \2 }'
  normal V=
endfunction

function! ExtractVariable()
  let name = input("Variable name: ")
  if name == ''
    return
  endif
  " Enter visual mode (not sure why this is needed since we're already in
  " visual mode anyway)
  normal! gv
  " Replace selected text with the variable name
  exec "normal c" . name
  " Define the variable on the line above
  exec "normal! O" . name . " = "
  " Paste the original selected text to be the variable value
  normal! $p
endfunction

function! CtrlPTestsDynamic()
  if isdirectory('test')
    let dir = 'test'
  else
    let dir = 'spec'
  end
  execute "" . g:ctrlp_cmd . " " . dir
endfunction


"""""""""""""""""""
" LEADER SHORTCUTS
"""""""""""""""""""

" Easy escape
imap <C-K> <Esc>

" CtrlP
map <leader>f :CtrlP<cr>
map <leader>b :CtrlPBuffer<cr>
map <leader>c :CtrlPTag<cr>
map <leader>r :CtrlPMRU<cr>
map <leader>f :CtrlP<cr>

" Rails
map <leader>gg :topleft 100 :split Gemfile<cr>
map <leader>gr :topleft :split config/routes.rb<cr>
map <leader>gR :call ShowRoutes()<cr>
map <leader>gst :CtrlP app/assets/stylesheets<cr>
map <leader>gja :CtrlP app/javascript<cr>
map <leader>gv :CtrlP app/views<cr>
map <leader>gc :CtrlP app/controllers<cr>
map <leader>gmo :CtrlP app/models<cr>
map <leader>gma :CtrlP app/mailers<cr>
map <leader>gse :CtrlP app/services<cr>
map <leader>gjo :CtrlP app/jobs<cr>
map <leader>gpr :CtrlP app/presenters<cr>
map <leader>gpo :CtrlP app/policies<cr>
map <leader>gh :CtrlP app/helpers<cr>
map <leader>gaa :CtrlP app/graphs/app_graph<cr>
map <leader>gac :CtrlP app/graphs/church_center_graph<cr>
map <leader>gl :CtrlP lib<cr>
map <leader>gt :call CtrlPTestsDynamic()<cr>

" Tests
nnoremap <leader>. :call OpenTestAlternate()<cr>
map <leader>t :VroomRunTestFile<cr>
map <leader>T :VroomRunNearestTest<cr>

" map <leader>rf :call AutoCop()<cr>

map <leader>w :call WriteCreatingDirs()<cr>

map <leader>en :lnext<cr>
map <leader>ep :lprev<cr>

" Ruby Refactoring
map <leader>rel :call PromoteToLet()<cr>
map <leader>rev :call ExtractVariable()<cr>

" The Silver Searcher (Ag)
map <leader>ag :Ack! 
map <leader>ac :Ack! <cword><cr>
map <leader>as :AckFromSearch!<cr>
map <leader>ai :Ack! -i 

" Copy to and paste from system clipboard
map <leader>p "*p<cr>
map <leader>P "*P<cr>
map <leader>y "*y<cr>

" Git
map <leader>u :diffupdate<cr>

" Delete to black hole register
map <leader>d "_d<cr>
map <leader>D "_dd<cr>

" Rename current file
map <leader>n :call RenameFile()<cr>

" Open .vimrc in a new tab
map <leader>v :tabe ~/.vimrc<cr>

" Reload .vimrc config
map <leader>V :source ~/.vimrc<cr>

imap <c-l> <space>=><space>

map <leader>C :tabnew<cr>
map <leader>s :!sh .git/hooks/ctags<cr>

nmap <space> zz

" Disable arrow keys
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

let g:ale_fixers = {
\   'javascript': ['prettier', 'eslint'],
\   'elixir': ['mix_format'],
\}
let g:ale_linters = {
\   'ruby': ['rubocop'],
\}
let g:ale_ruby_rubocop_executable = 'bundle'
let g:ale_fix_on_save = 1
let g:ale_set_highlights = 0
let g:airline#extensions#ale#enabled = 1

augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Enable spellchecking for Markdown fiels and Git commits
  autocmd BufRead,BufNewFile *.md setlocal spell
  autocmd FileType gitcommit setlocal spell

  " Automatically wrap at 80 characters for Markdown
  " autocmd BufRead,BufNewFile *.md setlocal numberwidth=4 columns=85 linebreak nolist

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()
augroup END

" Hide tab listchars in golang files
autocmd FileType go setlocal list listchars=tab:\ \ 

" Automatic split resizing
set winwidth=60
set winminwidth=60
set winwidth=120
set winheight=10
set winminheight=10
set winheight=999
