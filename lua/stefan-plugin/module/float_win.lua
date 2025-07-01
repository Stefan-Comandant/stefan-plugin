--- @param win_id integer the id of the window to kill
--- @param buf_id integer the id of the buffer inside the window which will be killed
local function kill_window(win_id, buf_id)
    if vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_win_close(win_id, true);
    end
    if vim.api.nvim_buf_is_valid(buf_id) then
        vim.api.nvim_buf_delete(buf_id, { force = true })
    end
end

--- @class button
--- @field text string
--- @field callback function

--- Make the floating window the current window 
--- @param cur_buf_id integer
--- @param new_buf_id integer
--- @param new_win_id integer
--- @param buttons button[] 
local function focus_float_window(cur_buf_id, new_buf_id, new_win_id, buttons)
    -- clear the autocmds on the buffer so that it doesn't detect a buffer leave and close the window
    vim.api.nvim_clear_autocmds({ buffer = cur_buf_id })

    vim.api.nvim_set_current_win(new_win_id)
    vim.api.nvim_win_set_cursor(new_win_id, { 1, 0 })

    vim.api.nvim_create_autocmd({"BufLeave"}, {
        buffer = new_buf_id,
        once = true,
        callback = function ()
            vim.api.nvim_buf_del_keymap(cur_buf_id, 'n', 'Z')
            kill_window(new_win_id, new_buf_id)
        end,
    })

    vim.api.nvim_buf_set_keymap(new_buf_id, 'n', 'q', '', {
        callback = function ()
            kill_window(new_win_id, new_buf_id)
        end,
    })


    vim.api.nvim_buf_set_keymap(new_buf_id, 'n', '<CR>', '', {
        callback = function ()
            local cursor_pos = vim.api.nvim_win_get_cursor(new_win_id)
            local line_num = cursor_pos[1]
            -- local char_index = cursor_pos[2]

            -- locate the button from the table using the cursor y position
            if buttons[line_num] ~= nil then
                buttons[line_num].callback()
            end
            kill_window(new_win_id, new_buf_id)
        end
    })

end

--- Create the new floating window and its buffer 
---@param buttons button[]
---@return integer new_buf_id id of the newly created buffer
---@return integer new_win_id id of the newly created window
local function create_win_and_buf(buttons)
    local new_buf_id = vim.api.nvim_create_buf(false, true)

    local popup_text = {}

    for _, button in pairs(buttons) do
        table.insert(popup_text, button.text)
    end

    vim.api.nvim_buf_set_lines(new_buf_id, 0, -1, false, popup_text)
    vim.api.nvim_set_option_value("bufhidden", "delete", { buf = new_buf_id })
    vim.api.nvim_set_option_value("modifiable", false, { buf = new_buf_id });

    local new_win_id = vim.api.nvim_open_win(new_buf_id, false, {
        width = 25,
        height = # (buttons), -- set height equal to the length of `buttons`
        relative = 'cursor',
        row = 0,
        col = 0,
        style = "minimal",
        focusable = true,
        mouse = true,
    })

    if new_win_id == 0 then
        print("There was an error when creating the floating window")
    end

    return new_win_id, new_buf_id
end

return { kill_window = kill_window, focus_float_window = focus_float_window, create_win_and_buf = create_win_and_buf, }
