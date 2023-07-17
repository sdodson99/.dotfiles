local map = vim.keymap.set;

-- Movement
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")

-- Formatting
map("n", "<leader>fp", function() vim.cmd.PrettierAsync() end, { desc = '[F]ormat [P]rettier' })
map("n", "<leader>fd", function() vim.lsp.buf.format({ timeout_ms = 5000, async = true }) end,
    { desc = '[F]ormat [D]efault' })

-- Telescoping
map('n', '<leader>sf', require 'telescope.builtin'.find_files, { desc = 'Tele[S]ope [F]ind Files' })
map('n', '<leader>sg', require 'telescope.builtin'.git_files, { desc = 'Tele[S]ope [G]it Files' })
map('n', '<leader>st', function() require 'telescope.builtin'.grep_string({ search = vim.fn.input("Grep > ") }) end,
    { desc = 'Tele[S]ope Grep S[T]ring' })

-- Harpooning
map("n", "<leader>ha", require 'harpoon.mark'.add_file, { desc = '[H]arpoon [A]dd' })
map("n", "<leader>hl", require 'harpoon.ui'.toggle_quick_menu, { desc = '[H]arpoon [L]ist' })
map("n", "<leader>h1", function() require 'harpoon.ui'.nav_file(1) end, { desc = '[H]arpoon File [1]' })
map("n", "<leader>h2", function() require 'harpoon.ui'.nav_file(2) end, { desc = '[H]arpoon File [2]' })
map("n", "<leader>h3", function() require 'harpoon.ui'.nav_file(3) end, { desc = '[H]arpoon File [3]' })
map("n", "<leader>h4", function() require 'harpoon.ui'.nav_file(4) end, { desc = '[H]arpoon File [4]' })
map("n", "<leader>h5", function() require 'harpoon.ui'.nav_file(5) end, { desc = '[H]arpoon File [5]' })

-- File Tree
map("n", "<leader>bt", vim.cmd.NvimTreeToggle, { desc = 'Tree [B]ar [T]oggle' })
map("n", "<leader>bf", vim.cmd.NvimTreeFindFile, { desc = 'Tree [B]ar [F]ind' })

-- Testing
map('n', '<leader>tr', function() require("neotest").run.run() end, { desc = '[T]est [R]un' })
map('n', '<leader>tf', function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = '[T]est [F]ile' })
map('n', '<leader>ts', function() require("neotest").summary.toggle() end, { desc = '[T]est [S]ummary' })

-- Debugging
map('n', '<leader>dct', function() require "dap".continue() end, { desc = '[D]ebugger [C]on[T]inue' })
map('n', '<leader>dsv', function() require "dap".step_over() end, { desc = '[D]ebugger [S]tep O[V]er' })
map('n', '<leader>dsi', function() require "dap".step_into() end, { desc = '[D]ebugger [S]tep [I]nto' })
map('n', '<leader>dso', function() require "dap".step_out() end, { desc = '[D]ebugger [S]tep [O]ut' })
map('n', '<leader>dtb', function() require "dap".toggle_breakpoint() end, { desc = '[D]ebugger [T]oggle [B]reakpoint' })
map('n', '<leader>dut', function() require "dapui".toggle() end, { desc = '[D]ebugger [U]I [T]oggle' })

-- LSP
map('n', '[d', vim.diagnostic.goto_prev, { desc = "Previous [D]iagnostic" })
map('n', ']d', vim.diagnostic.goto_next, { desc = "Next [D]iagnostic" })
map('n', 'gD', vim.lsp.buf.declaration, { desc = "[G]o to [D]eclaration" })
map('n', 'gd', vim.lsp.buf.definition, { desc = "[G]o to [D]efinition" })
map('n', 'K', vim.lsp.buf.hover)
map('n', 'gi', vim.lsp.buf.implementation, { desc = "[G]o to [I]mplementation" })
map('n', '<C-k>', vim.lsp.buf.signature_help)
map('n', '<space>rn', vim.lsp.buf.rename, { desc = "[R]e[N]ame" })
map({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
map('n', 'gr', vim.lsp.buf.references, { desc = "[G]o to [R]eferences" })
