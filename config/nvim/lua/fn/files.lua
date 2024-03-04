local files = {}

function files.rename()
    local old_name = vim.fn.expand("%")
    local new_name = vim.fn.input("New file name: ", vim.fn.expand("%"), "file")
    if new_name ~= "" and new_name ~= old_name then
        vim.cmd("Move " .. new_name)
    end
end

function files.write_p()
    os.execute("mkdir -p " .. vim.fn.expand("%:h"))
    vim.cmd.write()
end

function files.exists(filename)
    local stat = vim.loop.fs_stat(filename)
    return stat and stat.type or false
end

function files.is_dir(filename) return files.exists(filename) == "directory" end

function files.is_file(filename) return files.exists(filename) == "file" end

return files
