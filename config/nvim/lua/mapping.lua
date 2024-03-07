local files = require("fn.files")
local tests = require("fn.tests")
local rails = require("fn.rails")

-- Copy to and paste from system clipboard
vim.keymap.set({"n", "v"}, "<leader>p", '"*p<cr>')
vim.keymap.set({"n", "v"}, "<leader>P", '"*P<cr>')
vim.keymap.set({"n", "v"}, "<leader>y", '"*y<cr>')

-- reselect pasted text
vim.keymap.set("n", "gp", "`[v`]")

-- Open .vimrc in a new tab
vim.keymap.set("n", "<leader>v", ":Files ~/.config/nvim<cr>")

-- Reload .vimrc config
vim.keymap.set("n", "<leader>V", ":source ~/.config/nvim/init.lua<cr>")

vim.keymap.set("i", "<c-l>", "<space>=><space>")

vim.keymap.set("n", "<leader>C", ":tabnew<cr>")
vim.keymap.set("n", "<leader>S", ":!sh .git/hooks/ctags<cr>")

vim.keymap.set("n", "<space>", "zz")

-- Disable arrow keys
vim.keymap.set("n", "<Up>", "<NOP>")
vim.keymap.set("n", "<Down>", "<NOP>")
vim.keymap.set("n", "<Left>", "<NOP>")
vim.keymap.set("n", "<Right>", "<NOP>")

-- Move around splits with <c-hjkl>
vim.keymap.set("n", "<c-j>", "<c-w>j")
vim.keymap.set("n", "<c-k>", "<c-w>k")
vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-l>", "<c-w>l")

-- FZF
vim.keymap.set("n", "<leader>f", ":Files<cr>")
vim.keymap.set("n", "<leader>b", ":Buffers<cr>")
vim.keymap.set("n", "<leader>ca", ":Tags<cr>")
vim.keymap.set("n", "<leader>cf", ":BTags<cr>")

-- Rails
vim.keymap.set("n", "<leader>gg", ":topleft 100 :split Gemfile<cr>")
vim.keymap.set("n", "<leader>gr", ":topleft :split config/routes.rb<cr>")
vim.keymap.set("n", "<leader>gR", rails.show_routes)
vim.keymap.set("n", "<leader>gst", ":Files app/assets/stylesheets<cr>")
vim.keymap.set("n", "<leader>gja", ":Files app/javascript<cr>")
vim.keymap.set("n", "<leader>gv", ":Files app/views<cr>")
vim.keymap.set("n", "<leader>gc", ":Files app/controllers<cr>")
vim.keymap.set("n", "<leader>gmo", ":Files app/models<cr>")
vim.keymap.set("n", "<leader>gma", ":Files app/mailers<cr>")
vim.keymap.set("n", "<leader>gse", ":Files app/services<cr>")
vim.keymap.set("n", "<leader>gjo", ":Files app/jobs<cr>")
vim.keymap.set("n", "<leader>gpr", ":Files app/presenters<cr>")
vim.keymap.set("n", "<leader>gpo", ":Files app/policies<cr>")
vim.keymap.set("n", "<leader>gh", ":Files app/helpers<cr>")
vim.keymap.set("n", "<leader>gaa", ":Files app/graphs/app_graph<cr>")
vim.keymap.set("n", "<leader>gac", ":Files app/graphs/church_center_graph<cr>")
vim.keymap.set("n", "<leader>gl", ":Files lib<cr>")
vim.keymap.set("n", "<leader>gt", tests.fzf_test_files)
vim.keymap.set("n", "<leader>gf", ":Files test/fixtures<cr>")

-- Tests
vim.keymap.set("n", "<leader>.", tests.open_alternate)

-- The Silver Searcher (Ag)
vim.keymap.set("n", "<leader>ag", ":Ack! ")
vim.keymap.set("n", "<leader>ac", ":Ack! <cword><cr>")
vim.keymap.set("n", "<leader>as", ":AckFromSearch!<cr>")
vim.keymap.set("n", "<leader>ai", ":Ack! -i ")

-- Rename current file
vim.keymap.set("n", "<leader>n", files.rename)

-- Create parent directories and write
vim.keymap.set("n", "<leader>w", files.write_p)

