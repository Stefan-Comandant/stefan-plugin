local function kill_window(win_id, buf_id)
    if vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_win_close(win_id, true);
    end
    if vim.api.nvim_buf_is_valid(buf_id) then
        vim.api.nvim_buf_delete(buf_id, { force = true })
    end
end


return function ()
    local cur_buf_id = vim.api.nvim_get_current_buf()
    local new_buf_id = vim.api.nvim_create_buf(false, true)

    -- vim.api.nvim_buf_set_lines(new_buf_id, 0, -1, false, {"Black", "Guys"})
    vim.api.nvim_buf_set_lines(new_buf_id, 0, -1, false, {"Print", "Button 2"})
    vim.api.nvim_set_option_value("bufhidden", "delete", { buf = new_buf_id })
    vim.api.nvim_set_option_value("modifiable", false, { buf = new_buf_id });

    local new_win_id = vim.api.nvim_open_win(new_buf_id, false, {
        width = 25,
        height = 15,
        relative = 'cursor',
        row = 0,
        col = 0,
        style = "minimal",
        focusable = true,
        mouse = true,
        border = "solid"
    })

    if new_win_id == 0 then
        print("There was an error when creating the floating window")
    end

    vim.api.nvim_buf_set_keymap(cur_buf_id, 'n', 'Z', "", {
        callback = function ()
            -- clear the autocmds on the buffer so that it doesn't detect a buffer leave and close the window
            vim.api.nvim_clear_autocmds({ buffer = cur_buf_id })

            vim.api.nvim_set_current_win(new_win_id)
            vim.api.nvim_win_set_cursor(new_win_id, { 1, 0 })

            vim.api.nvim_create_autocmd({"BufLeave"}, {
                buffer = new_buf_id,
                callback = function ()
                    kill_window(new_win_id, new_buf_id)
                end,
                once = true,
            })

            vim.api.nvim_buf_set_keymap(new_buf_id, 'n', 'q', '', {
                callback = function ()
                    kill_window(new_win_id, new_buf_id)
                end
            })

            local buttons = {
                { callback = function ()
                    print("This is the first button")
                end}
            }

            vim.api.nvim_buf_set_keymap(new_buf_id, 'n', ' ', '', {
                callback = function ()
                    print("Spacebar was pressed")
                    local cursor_pos = vim.api.nvim_win_get_cursor(new_win_id)
                    local line_num = cursor_pos[1]
                    -- local char_index = cursor_pos[2]

                    -- locate the button from the table using the cursor y position
                    if buttons[line_num] ~= nil then
                        buttons[line_num].callback()
                    end
                end
            })

        end
    })


    -- nvim.api.nvim_create

    -- vim.api.nvim_set_hl(0, 'Visual', {})
    -- TODO: find out about highlights
    -- TODO: find out about how to listen to char input without keymaps

    vim.api.nvim_create_autocmd({"BufLeave", "CursorMoved", "InsertEnter"}, {
        buffer = cur_buf_id,
        callback = function ()
            kill_window(new_win_id, new_buf_id)
        end,
        once = true,
    })
end
