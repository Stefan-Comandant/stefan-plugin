local function kill_window(win_id, buf_id)
    if vim.api.nvim_win_is_valid(win_id) then
        vim.api.nvim_win_close(win_id, true);
    end
    if vim.api.nvim_buf_is_valid(buf_id) then
        vim.api.nvim_buf_delete(buf_id, { force = true })
    end
end

-- @param `buttons` -
-- @return - the IDs of the newly created window and buffer
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

return function ()
    local cur_buf_id = vim.api.nvim_get_current_buf()

    local buttons = {
        {
            text = "Build and Run Project",
            callback = function ()
                local cwd = vim.fn.getcwd()

                local opts = { detach = true, cwd = cwd }

                vim.system({"kitty", "--hold", "sh", "-c", "make -s -C " .. cwd ..  " build run"}, opts, function (out)
                    if out.code == 0 then
                        print("Build and run was successfull!")
                        return;
                    end
                    print("An error occured during the project build and run. Exit code: " .. out.code .. '\n')
                    print(out.stderr)
                end)
            end,
        },
        {
            text = "Build Project",
            callback = function ()
                local cwd = vim.fn.getcwd()

                vim.system({"make", "-C", cwd, "build"}, {}, function (out)
                    if out.code == 0 then
                        print("Build was completed successfully!")
                        return;
                    end


                    print("An error occured during the project build. Code: " .. out.code .. '\n')
                    print(out.stderr)
                end)
            end,
        },
        {
            text = "Run Project",
            callback = function ()
                local cwd = vim.fn.getcwd()

                local opts = { detach = true, cwd = cwd }

                vim.system({"kitty", "--hold", "sh", "-c", "make -s -C " .. cwd ..  " run"}, opts, function (out)
                    if out.code == 0 then
                        print("Project ran successfully!")
                        return;
                    end


                    print("An error occured during the project run. Exist code: " .. out.code .. '\n')
                    print(out.stderr)
                end)
            end,
        },
    }

    local new_win_id, new_buf_id = create_win_and_buf(buttons)

    vim.api.nvim_buf_set_keymap(cur_buf_id, 'n', 'Z', "", {
        callback = function ()
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
    })

    vim.api.nvim_create_autocmd({"BufLeave", "CursorMoved", "InsertEnter"}, {
        buffer = cur_buf_id,
        callback = function ()
            kill_window(new_win_id, new_buf_id)
        end,
        once = true,
    })
end
