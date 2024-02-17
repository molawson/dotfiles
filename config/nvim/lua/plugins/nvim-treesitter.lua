require("nvim-treesitter.configs").setup {
    ensure_installed = {
        "bash", "comment", "css", "go", "html", "javascript", "json", "lua",
        "regex", "ruby", "scss", "typescript", "vim"
    },
    highlight = {
        enable = true,
        disable = {"javascript"},
        additional_vim_regex_highlighting = false
    },
    indent = {enable = false},
    incremental_selection = {enable = true}
}
