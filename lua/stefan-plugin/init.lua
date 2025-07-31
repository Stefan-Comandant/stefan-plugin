local open_ter_win = "<cmd>10split | ter <CR><C-W>r"

vim.api.nvim_set_keymap("n", "<leader>ter", open_ter_win, { noremap = true, silent = true})

return {
    print_fname = require("stefan-plugin.module.print_file_name"),
    build = require("stefan-plugin..module.project_build"),
    read = require("stefan-plugin.module.visual_select_helper"),
}
