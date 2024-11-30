-- plugin-dependencies:
--     dense-analysis/ale
--      neovim/nvim-lspconfig
local files = require("fn.files")

local function gemfile_lock()
    local gemfile_lock = vim.fn.getcwd() .. "/Gemfile.lock"

    if vim.fn.filereadable(gemfile_lock) == 0 then return end

    return gemfile_lock
end

local function bundled_gem_version(gemname)
    local gemfile_lock = gemfile_lock()
    if not gemfile_lock then return end

    local version = nil

    for line in io.lines(gemfile_lock) do
        if string.find(line, "%s+" .. gemname .. " %(") then
            -- version must be major.minor for number based version compare
            version = string.match(line, "%d+%.%d+")
            break
        end
    end

    return tonumber(version)
end

local function is_bundled(gemname)
    return bundled_gem_version(gemname) and true or false
end

local function gem_supports_lsp(gemname)
    local initial_lsp_versions = {
        rubocop = 1.53,
        sorbet = 0.5,
        standard = 1.19,
        syntax_tree = 2.0
    }

    local lsp_version = initial_lsp_versions[gemname]

    if lsp_version then
        local bundled_version = bundled_gem_version(gemname)

        if bundled_version and bundled_version >= lsp_version then
            return true
        else
            return false
        end
    else
        return false
    end
end

if gemfile_lock() then
    local ale_fixers = {}
    local ale_linters = {}
    local lspconfig = require("lspconfig")

    -- TODO: make smarter about whether edna has ruby-lsp
    -- if is_bundled("edna") then
    --     lspconfig.ruby_lsp.setup({
    --         init_options = {linters = {"rubocop"}, formatter = "rubotree"}
    --     })
    -- else
    if is_bundled("standard") then
        if gem_supports_lsp("standard") then
            lspconfig.standardrb.setup({
                cmd = {"bundle", "exec", "standardrb", "--lsp"}
            })
        else
            vim.g.ale_ruby_standardrb_executable = "bundle"
            table.insert(ale_linters, "standardrb")
            table.insert(ale_fixers, "standardrb")
        end
    elseif is_bundled("rubocop") then
        if gem_supports_lsp("rubocop") then
            lspconfig.rubocop.setup({
                cmd = {"bundle", "exec", "rubocop", "--lsp"}
            })
        else
            vim.g.ale_ruby_rubocop_executable = "bundle"
            table.insert(ale_linters, "rubocop")
            table.insert(ale_fixers, "rubocop")
        end
    end

    if is_bundled("syntax_tree") then
        if gem_supports_lsp("syntax_tree") then
            lspconfig.syntax_tree.setup({
                cmd = {"bundle", "exec", "stree", "lsp"}
            })
        else
            vim.g.ale_ruby_syntax_tree_executable = "bundle"
            table.insert(ale_fixers, "syntax_tree")
        end
    end
    -- end

    if is_bundled("sorbet") then
        if gem_supports_lsp("sorbet") then
            lspconfig.sorbet.setup({
                cmd = {
                    "bundle", "exec", "srb", "tc", "--lsp", "--disable-watchman"
                }
            })
        else
            vim.g.ale_ruby_sorbet_executable = "bundle"
            table.insert(linters, "srb")
        end
    end

    local next_fixers = vim.g.ale_fixers or {}
    next_fixers.ruby = ale_fixers
    vim.g.ale_fixers = next_fixers

    local next_linters = vim.g.ale_linters or {}
    next_linters.ruby = ale_linters
    vim.g.ale_linters = next_linters
end
