-- Use tpope's markdown plugin instead
vim.g.polyglot_disabled = {"markdown"}

require("plug")

-- Remap leader key to ,
vim.g.mapleader = ","

-- Layout
vim.o.number = true
vim.o.relativenumber = true
vim.o.ruler = true
vim.o.showcmd = true
vim.o.laststatus = 2
vim.o.cc = 100
vim.o.list = true
vim.o.listchars = "tab:»·,trail:·"
vim.o.cursorline = true

-- Wrapping and indentation
vim.o.wrap = true
vim.o.scrolloff = 4
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.autoindent = true
vim.o.backspace = "indent,eol,start"

-- Automatic split resizing
vim.o.winwidth = 60
vim.o.winminwidth = 60
vim.o.winwidth = 120
vim.o.winheight = 10
vim.o.winminheight = 10
vim.o.winheight = 999

vim.o.encoding = "utf-8"

-- Search
vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

-- Clear the search buffer when hitting return
local function map_clear_search()
    vim.keymap.set("n", "<cr>", ":nohlsearch<cr>", {silent = true})
end
map_clear_search()

local vimrc_group = vim.api.nvim_create_augroup("vimrc", {clear = true})
-- Leave the return key alone when in command line windows, since it's used
-- to run commands there.
vim.api.nvim_create_autocmd("CmdwinEnter", {
    pattern = "*",
    callback = function() vim.keymap.del("n", "<cr>") end,
    group = vimrc_group
})
vim.api.nvim_create_autocmd("CmdwinLeave", {
    pattern = "*",
    callback = map_clear_search,
    group = vimrc_group
})

local function go_to_previous_cursor_position()
    if vim.bo.filetype == "gitcommit" then return end

    local line = vim.fn.line
    if line("'\"") > 0 and line("'\"") <= line("$") then
        vim.cmd.normal("g`\"")
    end
end
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = go_to_previous_cursor_position
})

vim.g.ackprg = "ag --vimgrep"

-- Markdown code block syntax highlighting
vim.g.markdown_fenced_languages = {
    "ruby", "eruby", "javascript", "html", "sh", "yaml"
}

-- Store all .swp files in a common location
vim.opt.directory:prepend("$HOME/.vim/tmp//")

require("theme")
require("statusline")
require("mapping")
require("plugins")
require("lang")

-- Search results highlighted with underline
vim.cmd.highlight({"Search", "ctermbg=None", "ctermfg=None", "cterm=underline"})
vim.cmd
    .highlight({"Search", "guibg=guibg", "guifg=guifg", "gui=underline,bold"})

-- Source per-project configuration from .git/vimrc if present
local git_dir = io.popen("git rev-parse --git-dir 2>/dev/null"):read("l")
if git_dir then
    local git_vimrc = git_dir .. "/vimrc"
    if vim.fn.glob(git_vimrc) ~= "" then vim.cmd.source(git_vimrc) end
end
