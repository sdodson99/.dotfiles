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

--- Formatting
map("n", "<leader>fp", function() vim.cmd.PrettierAsync() end, { desc = '[F]ormat [P]rettier' })
map("n", "<leader>fd", function() vim.lsp.buf.format({ timeout_ms = 5000, async = true }) end, { desc = '[F]ormat [D]efault' })

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
    'bluz71/nvim-linefly',
    config = function ()
      vim.g.linefly_options = {
        with_attached_clients = false,
      }
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      { 'windwp/nvim-ts-autotag' }
    },
    config = function ()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
	ensure_installed = { "typescript", 'tsx', "javascript", "html", "vim", "vimdoc", "lua", "json", "query" },
	sync_install = false,
        autotag = {
          enable = true
        },
	highlight = {
	  enable = true,
          additional_vim_regex_highlighting = false
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
    'mfussenegger/nvim-dap',
    keys = {
      { '<leader>dct', function() require "dap".continue() end, { desc = '[D]ebugger [C]on[T]inue' } },
      { '<leader>dsv', function() require "dap".step_over() end, { desc = '[D]ebugger [S]tep O[V]er' } },
      { '<leader>dsi', function() require "dap".step_into() end, { desc = '[D]ebugger [S]tep [I]nto' } },
      { '<leader>dso', function() require "dap".step_out() end, { desc = '[D]ebugger [S]tep [O]ut' } },
      { '<leader>dtb', function() require "dap".toggle_breakpoint() end, { desc = '[D]ebugger [T]oggle [B]reakpoint' } },
    },
    config = function ()
      require('dap').adapters.chrome = {
        type = "executable",
        command = "node",
        args = { vim.fn.stdpath("data") .. "/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js" }
      }
    end
  },
  {
    "rcarriga/nvim-dap-ui",
    keys = {
      { '<leader>dut', function() require "dapui".toggle() end, { desc = '[D]ebugger [U]I [T]oggle' } }
    },
    config = function ()
      require("dapui").setup({
        expand_lines = false,
        layouts = {
          {
            elements = {
              {
                id = "scopes",
                size = 1
              }
            },
            position = "right",
            size = 40
          }
        }
      })
    end
  },
  {
    'prettier/vim-prettier',
    build = "yarn install --frozen-lockfile --production",
    config = function ()
      vim.g['prettier#autoformat'] = 1;
      vim.g['prettier#autoformat_require_pragma'] = 0;
      vim.g['prettier#partial_format'] = 1;

      vim.api.nvim_create_user_command(
        'AutoFormat',
        function(opts)
          vim.g['prettier#autoformat'] = opts.fargs[1];
        end,
        { nargs = 1 }
      )
    end
  },
  {
    "tpope/vim-fugitive"
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
    cmd = { "LiveServerStart" },
    config = true
  }
})

vim.cmd('colorscheme catppuccin')
