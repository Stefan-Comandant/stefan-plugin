return function ()
    local cur_buf_id = vim.api.nvim_get_current_buf()
    local new_buf_id = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_lines(new_buf_id, 0, -1, false, {"Black", "Guys"})
    vim.api.nvim_set_option_value("bufhidden", "delete", { buf = new_buf_id })
    vim.api.nvim_set_option_value("modifiable", false, { buf = new_buf_id });

    -- the `enter` = false argument makes the user unable to focus the cursor on the window
    local new_win_id = vim.api.nvim_open_win(new_buf_id, false, {
        width = 22,
        height = 14,
        relative = 'cursor',
        row = 0,
        col = 0,
        style = "minimal",
        focusable = false,
        mouse = false,
    })

    if new_win_id == 0 then
        print("There was an error when creating the floating window")
    end

    vim.api.nvim_create_autocmd({"BufLeave", "CursorMoved"}, {
        buffer = cur_buf_id,
        callback = function ()
            if vim.api.nvim_win_is_valid(new_win_id) then
                vim.api.nvim_win_close(new_win_id, true);
            end
            if vim.api.nvim_buf_is_valid(new_buf_id) then
                vim.api.nvim_buf_delete(new_buf_id, { force = true })
            end
        end,
        once = true,
    })
end
