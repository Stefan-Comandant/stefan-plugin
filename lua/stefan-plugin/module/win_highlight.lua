-- Creates a highlight at the position of the cursor in the buf tied to the `new_buf_id` ID
return function (new_win_id, new_buf_id)
    local ns_id = vim.api.nvim_create_namespace("float-button-hl-ns")

    vim.api.nvim_set_hl(ns_id, "float-button-hl-gr", {
        reverse = true,
        bold = true,
    })

    vim.api.nvim_win_set_hl_ns(new_win_id, ns_id)

    vim.api.nvim_buf_clear_highlight(new_buf_id, ns_id, 0, -1)
    vim.api.nvim_buf_add_highlight(new_buf_id, ns_id, "float-button-hl-gr", vim.api.nvim_win_get_cursor(new_win_id)[1] - 1, 0, vim.api.nvim_win_get_width(new_win_id))
end
