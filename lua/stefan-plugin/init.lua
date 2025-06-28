-- local folderOfThisFile = (...):match("(.-)[^%.]+$") -- returns 'lib.foo.'
local modpath = (...)

-- local path = vim.fn.expand("%:h") .. "/";
-- function script_path()
--    local str = debug.getinfo(2, "S").source:sub(2)
--    return str;
-- end

local open_ter_win = "<cmd>10split | ter <CR><C-W>r"

vim.api.nvim_set_keymap("n", "<leader>ter",open_ter_win, {})
vim.api.nvim_set_keymap("n", "<leader>foo","", {
    callback = function ()
        -- print(scheisse)
        -- print(vim.fn.expand("%:p"))
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)

        -- print(lines[1]);
        for _, v in pairs(lines) do
            print(v .. "\n")
        end
    end,
})
local print_file_name = require(modpath .. '.module.print_file_name')

-- vim.fn.jobstart("neofetch");



return {
    do_foo = print_file_name,
    build = require(modpath .. ".module.project_build"),
    read = require(modpath .. ".module.visual_select_helper"),
}
