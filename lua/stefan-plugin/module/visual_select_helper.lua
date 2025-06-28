return function ()
    -- local vstart = vim.fn.getpos("'<");
    local vstart = vim.fn.getpos("v");
    -- local vend = vim.fn.getpos("'>");
    local vend = vim.fn.getpos(".");
    print("Start X: " .. vstart[1] .. "; Start Y: " .. vstart[2])
    print("End X: " .. vend[1] .. "; End Y: " .. vend[2])
    -- local cur_buf = vim.api.nvim_get_current_buf()

    -- local foo = vim.api.nvim_buf_get_text(0, vstart[1], vstart[2], vend[1], vend[2], { })

    -- for k, line in pairs(foo) do
    --     print(line)
    -- end
end
