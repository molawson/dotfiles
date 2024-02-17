if vim.g.airline_symbols == nil then vim.g.airline_symbols = vim.empty_dict() end

-- powerline symbols
vim.g.airline_left_sep = ""
vim.g.airline_left_alt_sep = ""
vim.g.airline_right_sep = ""
vim.g.airline_right_alt_sep = ""
vim.g.airline_symbols.branch = ""
vim.g.airline_symbols.readonly = ""
vim.g.airline_symbols.linenr = ""

vim.g.airline_section_b = ""
vim.g.airline_section_y = ""
vim.g.airline_section_z = vim.fn["airline#section#create"]({"linenr", ":%3v"})

vim.g.airline_theme = "sonokai"

vim.g["airline#extensions#ale#enabled"] = 1

vim.g.tmuxline_preset = {
    a = "#S",
    b = " #(cd #{pane_current_path};git ref)",
    win = "#I #W#F",
    cwin = "#I #W",
    y = "%a %b %d - %-l:%M %p",
    z = "#h #(battery_percentage)"
}

