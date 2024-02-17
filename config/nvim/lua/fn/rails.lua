local rails = {}

function rails.show_routes()
    vim.cmd("topleft 100 :split __Routes__")
    -- Make sure Vim doesn't write __Routes__ as a file
    vim.o.buftype = "nofile"
    -- Delete everything
    vim.cmd.normal("1GdG")
    -- Run routes command
    vim.cmd("0r! bundle exec rails routes")
    -- Size window to number of lines (1 plus rake output length)
    vim.cmd('exec ":normal " . line("$") . "_ "')
    -- Move cursor to bottom
    vim.cmd.normal("1GG")
    -- Delete empty trailing line
    vim.cmd.normal("dd")
end

return rails
