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

vim.diagnostic.config({
    underline = false,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = ""
        }
    }
})
