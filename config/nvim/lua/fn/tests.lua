local tests = {}

local function test_directory()
    if vim.fn.isdirectory("spec") == 1 then
        return "spec"
    else
        return "test"
    end
end

local function main_directory()
    if vim.fn.isdirectory("app") == 1 then
        return "app"
    else
        return "lib"
    end
end

function tests.alternate_for_current_file()
    local current_file = vim.fn.expand("%")
    local alternate_file = current_file

    local test_dir = test_directory()
    local main_dir = main_directory()

    if current_file:match(test_dir) then
        if test_dir == "spec" then
            alternate_file = alternate_file:gsub("_spec%.rb$", ".rb")
        else
            alternate_file = alternate_file:gsub("_test%.rb$", ".rb")
        end
        alternate_file = alternate_file:gsub(test_dir .. "/", main_dir .. "/")
    else
        if test_dir == "spec" then
            alternate_file = alternate_file:gsub("%.rb$", "_spec.rb")
        else
            alternate_file = alternate_file:gsub("%.rb$", "_test.rb")
        end
        alternate_file = alternate_file:gsub(main_dir .. "/", test_dir .. "/")
    end
    return alternate_file
end

function tests.open_alternate()
    vim.cmd("e " .. tests.alternate_for_current_file())
end

function tests.fzf_test_files() vim.cmd("Files " .. test_directory()) end

return tests
