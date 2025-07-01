local create_highlight = require("stefan-plugin.module.win_highlight")
local create_win_and_buf = require("stefan-plugin.module.float_win").create_win_and_buf
local kill_window = require("stefan-plugin.module.float_win").kill_window
local focus_float_window = require("stefan-plugin.module.float_win").focus_float_window


return function ()
    local cur_buf_id = vim.api.nvim_get_current_buf()

    --- @type button[]
    local buttons = {
        {
            text = "Build and run project",
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
            text = "Build project",
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
            end, },
        {
            text = "Run project",
            callback = function ()
                local cwd = vim.fn.getcwd()

                local opts = { detach = true, cwd = cwd }

                vim.system({"kitty", "--hold", "sh", "-c", "make -s -C " .. cwd ..  " run"}, opts, function (out)
                    if out.code == 0 then
                        -- print("Project ran successfully!")
                        return;
                    end


                    print("An error occured during the project run. Exist code: " .. out.code .. '\n')
                    print(out.stderr)
                end)
            end,
        },
    }

    local new_win_id, new_buf_id = create_win_and_buf(buttons)

    create_highlight(new_win_id, new_buf_id)

    focus_float_window(cur_buf_id, new_buf_id, new_win_id, buttons)

    vim.api.nvim_buf_set_keymap(cur_buf_id, 'n', 'Z', "", {
        callback = function ()
            focus_float_window(cur_buf_id, new_buf_id, new_win_id, buttons)
        end
    })

    vim.api.nvim_create_autocmd({"CursorMoved"}, {
        buffer = new_buf_id,
        callback = function ()
            create_highlight(new_win_id, new_buf_id)
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
