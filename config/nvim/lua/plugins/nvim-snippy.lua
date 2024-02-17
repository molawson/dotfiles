require("snippy").setup({
    scopes = {
        ruby = function(scopes)
            table.insert(scopes, "rails")
            return scopes
        end
    }
})
