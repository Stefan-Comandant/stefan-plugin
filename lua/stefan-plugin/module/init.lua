local function print_file_name()
    local file_name = vim.fn.expand("%:p");
    print(file_name);
end

return print_file_name
