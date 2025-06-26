-- local folderOfThisFile = (...):match("(.-)[^%.]+$") -- returns 'lib.foo.'
local modpath = (...)

-- local path = vim.fn.expand("%:h") .. "/";
-- function script_path()
--    local str = debug.getinfo(2, "S").source:sub(2)
--    return str;
-- end

local open_ter_win = " <cmd> split | ter <CR><cmd>resize -5<CR><C-W>r"

vim.api.nvim_set_keymap("n", "<leader>ter",open_ter_win, { })

local print_file_name = require(modpath .. '.module.init')

return {
    do_foo = print_file_name,
}
