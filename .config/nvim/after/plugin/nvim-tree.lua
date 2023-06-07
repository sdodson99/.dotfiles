-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

vim.keymap.set("n", "<leader>b", vim.cmd.NvimTreeToggle)

require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        width = 30,
        relativenumber = true,
        number = true
    },
    renderer = {
        group_empty = true,
    }
})
