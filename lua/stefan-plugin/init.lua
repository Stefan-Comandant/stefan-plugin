local function do_foo()
    local scheisse = 21;
    print(scheisse);
end

return {
    do_foo = do_foo,
}
