vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

vim.keymap.set("n", "<leader>gp", vim.cmd.PrettierAsync)
vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ timeout_ms = 5000 }) end)
