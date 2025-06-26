-- local folderOfThisFile = (...):match("(.-)[^%.]+$") -- returns 'lib.foo.'
local modpath = (...)

-- local path = vim.fn.expand("%:h") .. "/";
-- function script_path()
--    local str = debug.getinfo(2, "S").source:sub(2)
--    return str;
-- end

local exe = " <cmd> split | ter <CR>"

vim.api.nvim_set_keymap("n", "<leader>ter",exe, {})


local print_file_name = require(modpath .. '.module.init')

return {
    do_foo = print_file_name,
}
