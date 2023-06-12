vim.keymap.set('n', '<leader>tr', function() require("neotest").run.run() end)
vim.keymap.set('n', '<leader>tf', function() require("neotest").run.run(vim.fn.expand("%")) end)
vim.keymap.set('n', '<leader>ts', function() require("neotest").summary.toggle() end)

require("neotest").setup({
    adapters = {
        require("neotest-jest"),
        require("neotest-vitest"),
    },
})
