local better_term = nil

vim.api.nvim_set_keymap("n", "<leader>ter", "", { noremap = true, silent = true, callback = function ()
    if better_term == nil then
        better_term = require("betterTerm")
        better_term.setup {
            startInserted = false,
            position = "bot",
            size = 10,
        }
    end

    better_term.open()
end})

return {
    print_fname = require("stefan-plugin.module.print_file_name"),
    build = require("stefan-plugin..module.project_build"),
    read = require("stefan-plugin.module.visual_select_helper"),
}
