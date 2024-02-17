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
vim.g.ale_set_highlights = 0
