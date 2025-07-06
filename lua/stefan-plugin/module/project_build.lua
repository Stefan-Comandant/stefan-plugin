local create_highlight = require("stefan-plugin.module.win_highlight")
local create_win_and_buf = require("stefan-plugin.module.float_win").create_win_and_buf
local kill_window = require("stefan-plugin.module.float_win").kill_window
local focus_float_window = require("stefan-plugin.module.float_win").focus_float_window

--TODO: add feature to update cwd when the nvim-tree changes cwd
--TODO: add feature to allow custom buttons in the project.conf

return function ()
    local cur_buf_id = vim.api.nvim_get_current_buf()

    local pid = -1;

    --- @type button[]
    local buttons = {
        {
            text = "Build and run project",
            callback = function ()
                local cwd = vim.fn.getcwd()

                local file = io.open(cwd .. "/" .. "project.conf", "r+")
                local opts = { detach = true, cwd = cwd }
                if file == nil then
                    -- print(err)
                    -- do_default_action
                    -- end


                    local job = vim.system({"kitty", "--hold", "sh", "-c", "make -s -C " .. cwd ..  " build run"}, opts, function (out)
                        pid = -1;
                        if out.code == 0 then
                            print("Build and run was successfull!")
                            return;
                        end
                        print("An error occured during the project build and run. Exit code: " .. out.code .. '\n')
                        print(out.stderr)
                    end)

                    -- print("This is my kitty pid: " .. job.pid)
                else
                    -- handle config file

                    local build_cmd = file.read(file, "*l")
                    local run_cmd = file.read(file, "*l")

                    vim.system({"kitty", "--hold", "sh", "-c", build_cmd .. "  && " .. run_cmd}, opts, function (out)
                        if out.code == 0 then
                            -- print("Build and run was successfull!")
                            return;
                        end
                        print("An error occured during the project build and run. Exit code: " .. out.code .. '\n')
                        print(out.stderr)
                    end)

                    -- vim.system({"kitty", "--hold", "sh", "-c", run_cmd}, opts, function (out)
                        --     if out.code == 0 then
                        --         -- print("Project ran successfully!")
                        --         return;
                        --     end


                        --     print("An error occured during the project run. Exist code: " .. out.code .. '\n')
                        --     print(out.stderr)
                        -- end)

                        file.close(file)
                    end
                end,
            },
        {
            text = "Build project",
            callback = function ()
                local cwd = vim.fn.getcwd()

                local opts = { detach = true, cwd = cwd }
                local file = io.open(cwd .. "/" .. "project.conf", "r+")
                if file == nil then
                    vim.system({"make", "-C", cwd, "build"}, opts, function (out)
                        if out.code == 0 then
                            print("Build was completed successfully!")
                            return;
                        end


                        print("An error occured during the project build. Code: " .. out.code .. '\n')
                        print(out.stderr)
                    end)

                else
                    local build_cmd = file.read(file, "*l")
                    vim.system({"zsh", "-c", build_cmd}, opts, function (out)
                        if out.code == 0 then
                            print("Build was completed successfully!")
                            return;
                        end


                        print("An error occured during the project build. Code: " .. out.code .. '\n')
                        print(out.stderr)
                    end)
                    file.close(file)
                end
            end, },
        {
            text = "Run project",
            callback = function ()
                local cwd = vim.fn.getcwd()

                local opts = { detach = true, cwd = cwd }
                local file = io.open(cwd .. "/" .. "project.conf", "r+")
                if file == nil then
                    vim.system({"kitty", "--hold", "sh", "-c", "make -s -C " .. cwd ..  " run"}, opts, function (out)
                        if out.code == 0 then
                            -- print("Project ran successfully!")
                            return;
                        end


                        print("An error occured during the project run. Exist code: " .. out.code .. '\n')
                        print(out.stderr)
                    end)
                else
                    local _ = file.read(file, "*l")
                    local run_cmd = file.read(file, "*l")
                    vim.system({"kitty", "--hold", "sh", "-c", run_cmd}, opts, function (out)
                        if out.code == 0 then
                            -- print("Project ran successfully!")
                            return;
                        end


                        print("An error occured during the project run. Exist code: " .. out.code .. '\n')
                        print(out.stderr)
                    end)
                    file.close(file)
                end

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
