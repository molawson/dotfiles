vim.g.ale_fixers = {
    javascript = {"prettier", "eslint"},
    javascriptreact = {"prettier", "eslint"},
    typescript = {"prettier", "eslint"},
    typescriptreact = {"prettier", "eslint"},
    yaml = {"prettier"},
    elixir = {"mix_format"},
    go = {"gofmt"},
    lua = {"lua-format"}
}
vim.g.ale_linters = {ruby = {"rubocop", "srb", "standard"}}
vim.g.ale_fix_on_save = 1
vim.g.ale_echo_cursor = 0
vim.g.ale_use_neovim_diagnostics_api = 1
vim.g["airline#extensions#ale#enabled"] = 0
