local lsp = require('lsp-zero').preset("recommended")

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
end)

lsp.ensure_installed({ 'tsserver', 'eslint', 'html', 'lua_ls' })

lsp.configure('html', {
    filetypes = { 'html', 'handlebars' }
})

require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()
