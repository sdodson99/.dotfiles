-- Options

vim.g.mapleader = " ";
vim.opt.guicursor = "";
vim.opt.number = true;
vim.opt.relativenumber = true;
vim.opt.wrap = false;
vim.opt.shiftwidth = 2;
vim.opt.swapfile = false;

-- Keybinds

local map = vim.keymap.set;

--- Movement
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")

-- Lazy.nvim Setup

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Plugins!

require("lazy").setup({
  -- LSP Things That I Totally Understand
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    lazy = true,
    config = false,
    init = function()
      vim.g.lsp_zero_extend_cmp = 0
      vim.g.lsp_zero_extend_lspconfig = 0
    end,
  },
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = true,
  },
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'saadparwaiz1/cmp_luasnip',
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets"
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()

      local lsp_zero = require('lsp-zero')

      lsp_zero.extend_cmp()

      local cmp = require('cmp')
      local cmp_action = lsp_zero.cmp_action()

      cmp.setup({
	formatting = lsp_zero.cmp_format(),
	mapping = cmp.mapping.preset.insert({
	  ['<C-Space>'] = cmp.mapping.complete(),
	  ['<C-u>'] = cmp.mapping.scroll_docs(-4),
	  ['<C-d>'] = cmp.mapping.scroll_docs(4),
	  ['<C-f>'] = cmp_action.luasnip_jump_forward(),
	  ['<C-b>'] = cmp_action.luasnip_jump_backward(),
	}),
	snippet = {
	  expand = function(args)
	    require("luasnip").lsp_expand(args.body)
	  end,
	},
	sources = cmp.config.sources({
	  { name = "luasnip" },
	}),
      })
    end
  },
  {
    'neovim/nvim-lspconfig',
    cmd = {'LspInfo', 'LspInstall', 'LspStart'},
    event = {'BufReadPre', 'BufNewFile'},
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'},
      {'williamboman/mason-lspconfig.nvim'},
    },
    config = function()
      local lsp_zero = require('lsp-zero')

      lsp_zero.extend_lspconfig()

      lsp_zero.on_attach(function(_, bufnr)
	lsp_zero.default_keymaps({buffer = bufnr})
      end)

      require('mason-lspconfig').setup({
	ensure_installed = {},
	handlers = {
	  lsp_zero.default_setup,
	  lua_ls = function()
	    local lua_opts = lsp_zero.nvim_lua_ls()
	    require('lspconfig').lua_ls.setup(lua_opts)
	  end,
	}
      })
    end
  },

  -- Other Things That I Actually Understand
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000,
    config = function()
      vim.cmd('colorscheme rose-pine')
    end
  },
  {
    'ThePrimeagen/harpoon',
    keys = {
      { "<leader>ha", function() require 'harpoon.mark'.add_file() end, { desc = '[H]arpoon [A]dd' } },
      { "<leader>hl", function() require 'harpoon.ui'.toggle_quick_menu() end, { desc = '[H]arpoon [L]ist' } },
      { "<leader>h1", function() require 'harpoon.ui'.nav_file(1) end, { desc = '[H]arpoon File [1]' } },
      { "<leader>h2", function() require 'harpoon.ui'.nav_file(2) end, { desc = '[H]arpoon File [2]' } },
      { "<leader>h3", function() require 'harpoon.ui'.nav_file(3) end, { desc = '[H]arpoon File [3]' } },
      { "<leader>h4", function() require 'harpoon.ui'.nav_file(4) end, { desc = '[H]arpoon File [4]' } },
      { "<leader>h5", function() require 'harpoon.ui'.nav_file(5) end, { desc = '[H]arpoon File [5]' } }
    },
    dependencies = {
      'nvim-lua/plenary.nvim'
    }
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {}
  },
})

