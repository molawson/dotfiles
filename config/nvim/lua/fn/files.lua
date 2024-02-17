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

return files
