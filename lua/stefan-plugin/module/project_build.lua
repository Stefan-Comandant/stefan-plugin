return function ()
    -- vim.api.nvim_command("make build")

    -- save current window and cursor position
    local cur_win_id = vim.api.nvim_get_current_win()
    local cur_buf_id = vim.api.nvim_get_current_buf()
    local cur_cursor_pos = vim.api.nvim_win_get_cursor(cur_win_id)

    local new_buf_id = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_lines(new_buf_id, 0, -1, false, {"Black", "Guys"})

    -- vim.api.nvim_set_option_value("buftype", "quickfix", {
    --     buf = new_buf_id,
    -- })

    vim.api.nvim_set_option_value("bufhidden", "delete", {
        buf = new_buf_id,
    })

    vim.api.nvim_set_option_value("modifiable", false, {
        buf = new_buf_id,
    });

    -- vim.api.nvim_set_option_value("bufhidden", "wipe", {
    --     buf = new_buf_id,
    -- });

    -- vim.api.nvim_buf_set_option(new_buf_id, "number", false);
    -- vim.api.nvim_buf_set_option
    -- vim.api.nvim_buf_set_option(new_buf_id, "buftype", "quickfix");
    -- vim.api.nvim_win_set_config
    -- vim.api.()

    -- assigns the buffer with the id `new_buf_id` to window `id`
    -- vim.api.nvim_win_set_buf(id, new_buf_id)

    --!!! the `enter` = false argument makes the user unable to focus the cursor on the window
    local id = vim.api.nvim_open_win(new_buf_id, false, {
        -- vertical = true,
        width = 22,
        height = 14,
        relative = 'cursor',
        row = 0,
        col = 0,
        style = "minimal",
        focusable = false,
        mouse = false,
        title = "Scheisse",
        -- noautocmd = true,
    })

    if id == 0 then
        print("There was an error when creating the floating window")
    end

    vim.api.nvim_create_autocmd({"BufLeave", "CursorMoved"}, {
        buffer = cur_buf_id,
        callback = function (autocmd)
            vim.api.nvim_buf_delete(new_buf_id, { force = true })
            vim.api.nvim_win_close(id, true);
            vim.api.nvim_del_autocmd(autocmd.id)
        end,
    })
end
