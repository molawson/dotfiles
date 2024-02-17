local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
               vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col,
                                                                          col)
                   :match("%s") == nil
end

local snippy = require("snippy")
local cmp = require("cmp")

cmp.setup({
    snippet = {
        expand = function(args)
            require("snippy").expand_snippet(args.body) -- For `snippy` users.
        end
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
        end, {"i", "s"}),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif snippy.can_jump(-1) then
                snippy.previous()
            else
                fallback()
            end
        end, {"i", "s"}),
        ["<CR>"] = cmp.mapping.confirm({select = true}),
        ["<C-r>"] = cmp.mapping.complete()
    },
    completion = {autocomplete = false, completeopt = "menu,menuone,noinsert"},
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({tags = "[Tag]", buffer = "[Buffer]"})[entry.source
                                .name]
            return vim_item
        end
    },
    sources = cmp.config.sources({
        {name = "tags"}, {name = "snippy"}, {name = "buffer"}
    })
})
