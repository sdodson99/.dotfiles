require("neotest").setup({
    adapters = {
        require("neotest-jest"),
        require("neotest-vitest"),
    },
    quickfix = {
        open = false
    }
})
