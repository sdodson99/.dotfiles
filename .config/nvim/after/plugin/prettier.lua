vim.g['prettier#autoformat'] = 1;
vim.g['prettier#autoformat_require_pragma'] = 0;

vim.api.nvim_create_user_command(
    'AutoFormat',
    function(opts)
        vim.g['prettier#autoformat'] = opts.fargs[1];
    end,
    { nargs = 1 }
)
