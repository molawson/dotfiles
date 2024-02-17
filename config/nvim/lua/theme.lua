vim.o.termguicolors = true

local sonokaiCustomGroup = vim.api.nvim_create_augroup("SonokaiCustom",
                                                       {clear = true})
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "sonokai",
    group = sonokaiCustomGroup,
    callback = function()
        vim.cmd([[
            highlight! link TSLabel OrangeItalic
            highlight! link TSConstant Orange
        ]])
    end
})

vim.g.sonokai_enable_italic = 1
vim.cmd.colorscheme("sonokai")

vim.fn.sign_define("DiagnosticSignError",
                   {text = "", texthl = "DiagnosticSignError", numhl = ""})
vim.fn.sign_define("DiagnosticSignWarn",
                   {text = "", texthl = "DiagnosticSignWarn", numhl = ""})
vim.fn.sign_define("DiagnosticSignInfo",
                   {text = "", texthl = "DiagnosticSignInfo", numhl = ""})
vim.fn.sign_define("DiagnosticSignHint",
                   {text = "", texthl = "DiagnosticSignHint", numhl = ""})

vim.diagnostic.config({underline = false})
