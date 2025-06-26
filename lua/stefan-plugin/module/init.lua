local function print_file_name()
    local file_extension = vim.fn.expand("%:p");
    print(file_extension);

    -- if file_extension == "txt" then
        -- vim.cmd "echo \"scheisse\""
    -- end

end

return print_file_name
