local dap = require('dap');

dap.adapters.chrome = {
    type = "executable",
    command = "node",
    args = { os.getenv("HOME") .. "/.config/nvim/debuggers/vscode-chrome-debug/out/src/chromeDebug.js" }
}

vim.keymap.set('n', '<leader>dlc',
    function() require('dap.ext.vscode').load_launchjs(nil, { chrome = { 'typescriptreact' } }) end)

vim.keymap.set('n', '<leader>dct', '<cmd>lua require"dap".continue()<CR>')
vim.keymap.set('n', '<leader>dsv', '<cmd>lua require"dap".step_over()<CR>')
vim.keymap.set('n', '<leader>dsi', '<cmd>lua require"dap".step_into()<CR>')
vim.keymap.set('n', '<leader>dso', '<cmd>lua require"dap".step_out()<CR>')
vim.keymap.set('n', '<leader>dtb', '<cmd>lua require"dap".toggle_breakpoint()<CR>')
vim.keymap.set('n', '<leader>dsc', '<cmd>lua require"dap.ui.variables".scopes()<CR>')
vim.keymap.set('n', '<leader>dhh', '<cmd>lua require"dap.ui.variables".hover()<CR>')
vim.keymap.set('v', '<leader>dhv', '<cmd>lua require"dap.ui.variables".visual_hover()<CR>')
