-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        width = 40,
        relativenumber = true,
        number = true,
        side = 'right'
    },
    renderer = {
        group_empty = true,
    },
    git = {
        ignore = false
    }
})
