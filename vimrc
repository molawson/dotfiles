" Inspiration (and much of the actual code) from Gary Bernhardt's dotfiles (https://github.com/garybernhardt/dotfiles)

" Use tpope's markdown plugin instead
let g:polyglot_disabled = ['markdown']

call plug#begin('~/.vim/plugged')
Plug 'mileszs/ack.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'vim-scripts/matchit.zip'
Plug 'tomtom/tlib_vim'
Plug 'edkolev/tmuxline.vim'
Plug 'tpope/vim-abolish'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Townk/vim-autoclose'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'ecomba/vim-ruby-refactoring'
Plug 'honza/vim-snippets'
Plug 'dcampos/nvim-snippy'
Plug 'quangnguyen30192/cmp-nvim-tags'
Plug 'dcampos/cmp-snippy'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'tpope/vim-surround'
Plug 'skalnik/vim-vroom'
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'sheerun/vim-polyglot'
Plug 'sainnhe/sonokai'
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
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

" reselect pasted text
nnoremap gp `[v`]

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

let g:airline_theme = 'sonokai'

let g:tmuxline_preset = {
      \ 'a': '#S',
      \ 'b': ' #(cd #{pane_current_path};git ref)',
      \ 'win': '#I #W#F',
      \ 'cwin': '#I #W',
      \ 'y': '%a %b %d - %-l:%M %p',
      \ 'z': '#h #(battery_percentage)'}


" Display
syntax on
set guifont=Fira\ Code:h15
set encoding=utf-8

if has('termguicolors')
  set termguicolors
endif

function! s:sonokai_custom()
  highlight! link TSLabel OrangeItalic
  highlight! link TSConstant Orange
endfunction

augroup SonokaiCustom
  autocmd!
  autocmd ColorScheme sonokai call s:sonokai_custom()
augroup END

let g:sonokai_enable_italic = 1
colorscheme sonokai

set list listchars=tab:»·,trail:·
set cursorline

" Search
set hlsearch
set incsearch
set ignorecase
set smartcase

" Search results highlighted with underline
highlight Search ctermbg=None ctermfg=None cterm=underline
highlight Search guibg=guibg guifg=guifg gui=underline,bold

" Clear the search buffer when hitting return
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()

" FZF
let $FZF_DEFAULT_COMMAND='ag -lU --hidden --nocolor -g ""'
let $FZF_DEFAULT_OPTS='--layout=reverse'

let g:vroom_test_unit_command = 'bin/rails test '
let g:vroom_use_bundle_exec = 0
let g:vroom_use_terminal = 1

let g:jsx_ext_required = 0

if executable('ag')
  let g:ackprg = 'ag -F --vimgrep'
endif

" Bash style tab completion
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*

" Markdown code block syntax highlighting
let g:markdown_fenced_languages=['ruby', 'eruby', 'javascript', 'html', 'sh']

au! BufRead,BufNewFile *.pp setfiletype ruby

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

function! OpenCurrentFileTigLog()
  let current_file = expand('%')
  tabnew | call termopen('tig log -- '.current_file) | startinsert
endfunction
command Glog call OpenCurrentFileTigLog()

function! OpenCurrentFileTigBlame()
  let current_file = expand('%')
  tabnew | call termopen('tig blame -- '.current_file) | startinsert
endfunction
command Gblame call OpenCurrentFileTigBlame()


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

function! FZFTestsDynamic()
  if isdirectory('test')
    let dir = 'test'
  else
    let dir = 'spec'
  end
  execute ":Files" . " " . dir
endfunction


" Run sorbet typcheck like vim-vroom
function! RunSorbetTypeCheck()
  let cmd = 'bundle exec srb tc --file '. expand('%')
  if exists('t:srb_terminal_bufnr') && bufexists(t:srb_terminal_bufnr)
    exec ":bd! ".t:srb_terminal_bufnr
  end

  let height = winheight(0) * 1/4
  exec ":belowright " . height . "split"

  exec ":terminal " . cmd
  " terminal runs by default in insert mode which kills the buffer after exit,
  " let's change to normal mode
  exec ":stopinsert"
  let t:srb_terminal_bufnr = bufnr('%')
endfunction


"""""""""""""""""""
" LEADER SHORTCUTS
"""""""""""""""""""

" FZF
map <leader>f :Files<cr>
map <leader>b :Buffers<cr>
map <leader>ca :Tags<cr>
map <leader>cf :BTags<cr>

" Rails
map <leader>gg :topleft 100 :split Gemfile<cr>
map <leader>gr :topleft :split config/routes.rb<cr>
map <leader>gR :call ShowRoutes()<cr>
map <leader>gst :Files app/assets/stylesheets<cr>
map <leader>gja :Files app/javascript<cr>
map <leader>gv :Files app/views<cr>
map <leader>gc :Files app/controllers<cr>
map <leader>gmo :Files app/models<cr>
map <leader>gma :Files app/mailers<cr>
map <leader>gse :Files app/services<cr>
map <leader>gjo :Files app/jobs<cr>
map <leader>gpr :Files app/presenters<cr>
map <leader>gpo :Files app/policies<cr>
map <leader>gh :Files app/helpers<cr>
map <leader>gaa :Files app/graphs/app_graph<cr>
map <leader>gac :Files app/graphs/church_center_graph<cr>
map <leader>gl :Files lib<cr>
map <leader>gt :call FZFTestsDynamic()<cr>

" Tests
nnoremap <leader>. :call OpenTestAlternate()<cr>
map <leader>t :VroomRunTestFile<cr>
map <leader>T :VroomRunNearestTest<cr>

map <leader>s :call RunSorbetTypeCheck()<cr>

map <leader>w :call WriteCreatingDirs()<cr>

" The Silver Searcher (Ag)
map <leader>ag :Ack! 
map <leader>ac :Ack! <cword><cr>
map <leader>as :AckFromSearch!<cr>
map <leader>ai :Ack! -i 

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

" Reload .vimrc config
map <leader>V :source ~/.vimrc<cr>

imap <c-l> <space>=><space>

map <leader>C :tabnew<cr>
map <leader>S :!sh .git/hooks/ctags<cr>

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
\   'ruby': ['prettier'],
\   'elixir': ['mix_format'],
\}
let g:ale_linters = {
\   'ruby': ['rubocop', 'srb'],
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

" tree-sitter
lua <<EOF
require"nvim-treesitter.configs".setup {
  ensure_installed = {
    "bash", "comment", "css", "go", "html", "javascript", "json", "lua", "regex", "ruby", "scss",
    "typescript", "vim"
  },
  highlight = { 
    enable = true,
    disable = { "javascript" },
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = false },
  incremental_selection = { enable = true },
}
EOF

" cmp
lua <<EOF
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local snippy = require("snippy")
  local cmp = require("cmp")

  cmp.setup({
    snippet = {
      expand = function(args)
        require'snippy'.expand_snippet(args.body) -- For `snippy` users.
      end,
    },
    mapping = {
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif snippy.can_expand_or_advance() then
          snippy.expand_or_advance()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif snippy.can_jump(-1) then
          snippy.previous()
        else
          fallback()
        end
      end, { "i", "s" }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<C-r>'] = cmp.mapping.complete(),
    },
    completion = {
      autocomplete = false,
      completeopt = "menu,menuone,noinsert"
    },
    formatting = {
      format = function(entry, vim_item)
        vim_item.menu = ({
          tags = "[Tag]",
          buffer = "[Buffer]",
        })[entry.source.name]
        return vim_item
      end
    },
    sources = cmp.config.sources({
      { name = 'tags' },
      { name = 'snippy' },
      { name = 'buffer' },
    })
  })
EOF

" snippy
lua <<EOF
  require('snippy').setup({
    scopes = {
      ruby = function(scopes)
        table.insert(scopes, 'rails')
        return scopes
      end,
    }
  })
EOF

" Automatic split resizing
set winwidth=60
set winminwidth=60
set winwidth=120
set winheight=10
set winminheight=10
set winheight=999

" Git specific configuration
let git_path = system("git rev-parse --git-dir 2>/dev/null")
let git_vimrc = substitute(git_path, '\n', '', '') . "/vimrc"
if !empty(glob(git_vimrc))
    exec ":source " . git_vimrc
endif
