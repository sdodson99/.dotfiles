-- Options

vim.g.mapleader = " ";
vim.g.loaded_netrw = 1;
vim.g.loaded_netrwPlugin = 1;
vim.opt.guicursor = "";
vim.opt.number = true;
vim.opt.relativenumber = true;
vim.opt.wrap = false;
vim.opt.shiftwidth = 2;
vim.opt.swapfile = false;
vim.opt.expandtab = true;
vim.opt.termguicolors = true;
vim.opt.signcolumn = "yes";
vim.opt.scrolloff = 8;

-- Keybinds

local map = vim.keymap.set;

--- Movement
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")

--- File Tree
map("n", "<leader>bt", vim.cmd.NvimTreeToggle, { desc = 'Tree [B]ar [T]oggle' })
map("n", "<leader>bf", vim.cmd.NvimTreeFindFile, { desc = 'Tree [B]ar [F]ind' })

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
	    require('luasnip').lsp_expand(args.body)
	  end,
	},
	sources = cmp.config.sources({
	  { name = 'nvim_lsp' },
	  { name = 'luasnip' }
	}, {
	    { name = 'buffer' },
	})
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
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require('catppuccin').setup({
	transparent_background = true
      })
    end
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000,
    config = function()
      require('rose-pine').setup({
	disable_background = true
      })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag"
    },
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
	ensure_installed = { "lua", "typescript", "javascript", "html" },
	sync_install = false,
	autotag = {
	  enable = true,
          enable_rename = true,
          enable_close = true,
          enable_close_on_slash = true,
          filetypes = { "html" , "typescript", "javascript", "typescriptreact", "javascriptreact" },
	},
	highlight = {
	  enable = true
	},
	indent = {
	  enable = true
	},
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {}
  },
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git"
    }
  },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      { '<leader>sf', function() require 'telescope.builtin'.find_files() end, { desc = 'Tele[S]ope [F]ind Files' } },
      { '<leader>sg', function() require 'telescope.builtin'.git_files() end, { desc = 'Tele[S]ope [G]it Files' } },
      { '<leader>st', function() require 'telescope.builtin'.grep_string({ search = vim.fn.input("Grep > ") }) end, { desc = 'Tele[S]ope Grep S[T]ring' } }
    }
  },
  {
    'ThePrimeagen/harpoon',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    keys = {
      { "<leader>ha", function() require 'harpoon.mark'.add_file() end, { desc = '[H]arpoon [A]dd' } },
      { "<leader>hl", function() require 'harpoon.ui'.toggle_quick_menu() end, { desc = '[H]arpoon [L]ist' } },
      { "<leader>h1", function() require 'harpoon.ui'.nav_file(1) end, { desc = '[H]arpoon File [1]' } },
      { "<leader>h2", function() require 'harpoon.ui'.nav_file(2) end, { desc = '[H]arpoon File [2]' } },
      { "<leader>h3", function() require 'harpoon.ui'.nav_file(3) end, { desc = '[H]arpoon File [3]' } },
      { "<leader>h4", function() require 'harpoon.ui'.nav_file(4) end, { desc = '[H]arpoon File [4]' } },
      { "<leader>h5", function() require 'harpoon.ui'.nav_file(5) end, { desc = '[H]arpoon File [5]' } }
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {
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
      }
    end,
  },
  {
    'numToStr/Comment.nvim',
    opts = {},
    lazy = false,
  },
  {
    "iamcco/markdown-preview.nvim",
    name = "markdown-preview",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    'barrett-ruth/live-server.nvim',
    build = 'yarn global add live-server',
    config = true
  }
})

vim.cmd('colorscheme catppuccin')
