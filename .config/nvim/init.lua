-- Options

vim.g.mapleader = " ";
vim.opt.guicursor = "";
vim.opt.number = true;
vim.opt.relativenumber = true;
vim.opt.wrap = false;
vim.opt.shiftwidth = 2;
vim.opt.swapfile = false;
vim.opt.backup = false;
vim.opt.expandtab = true;
vim.opt.termguicolors = true;
vim.opt.signcolumn = "yes";
vim.opt.scrolloff = 8;
vim.opt.undofile = true;

-- Keybinds

local map = vim.keymap.set;

--- Movement
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")

--- LSP
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gr", vim.lsp.buf.references, { desc = "Show references" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover info" })

-- Commands
vim.api.nvim_create_user_command(
  'AutoFormat',
  function(opts)
    vim.g.auto_format = opts.fargs[1];
  end,
  { nargs = 1 }
)

-- Plugin Manager

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Plugins

require("lazy").setup({
  -- LSP
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "html",
          "eslint"
        },
        automatic_enable = true
      })
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter")

      configs.setup({
        ensure_installed = {
          "vim",
          "vimdoc",
          "lua",
          "html",
          "javascript",
          "json",
          "typescript",
          "tsx"
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
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require 'treesitter-context'.setup {
        max_lines = 3,
      }
    end
  },

  -- Completion
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    event = 'InsertEnter',
    opts = {
      keymap = { preset = 'default' },
      completion = {
        documentation = {
          auto_show = true
        }
      },
      fuzzy = {
        implementation = "lua"
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      }
    }
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {}
  },
  {
    'windwp/nvim-ts-autotag',
    event = "InsertEnter",
    opts = {
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true
      }
    }
  },
  {
    'stevearc/conform.nvim',
    event = { "BufWritePre" },
    opts = {
      formatters_by_ft = {
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        javascriptreact = { "prettierd" },
        typescriptreact = { "prettierd" },
        json = { "prettierd" },
        css = { "prettierd" },
        html = { "prettierd" }
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = function()
        if vim.g.auto_format == "0" then
          return
        end

        return { timeout_ms = 5000 }
      end,
    },
    keys = {
      {
        "<leader>fp",
        function()
          require("conform").format({ formatters = { "prettierd" } })
        end,
        mode = { "n", "v" },
        desc = "Format with prettierd",
      },
      {
        "<leader>fd",
        function()
          require("conform").format()
        end,
        mode = { "n", "v" },
        desc = "Format with default formatter",
      },
      {
        "<leader>fi",
        ":ConformInfo<CR>",
        desc = "Show conform.nvim status",
      },
    },
  },
  {
    'numToStr/Comment.nvim',
    opts = {}
  },

  -- Navigation
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      "natecraddock/workspaces.nvim",
      "nvim-tree/nvim-web-devicons"
    },
    keys = {
      {
        '<leader>sf',
        function() require 'telescope.builtin'.find_files() end,
        desc =
        'Telescope - Search Find Files'
      },
      {
        '<leader>sg',
        function() require 'telescope.builtin'.git_files() end,
        desc =
        'Telescope - Search Git Files'
      },
      {
        '<leader>st',
        function() require 'telescope.builtin'.grep_string({ search = vim.fn.input("Grep > ") }) end,
        desc =
        'Telescope - Grep String'
      },
      {
        '<leader>sk',
        function() require 'telescope.builtin'.keymaps() end,
        desc =
        'Telescope - Search Keymaps'
      },
      {
        '<leader>sc',
        function() require 'telescope.builtin'.colorscheme() end,
        desc =
        'Telescope - Search Color Schemes'
      },
      {
        "<leader>sp",
        function() vim.cmd.Telescope('workspaces') end,
        desc =
        'Telescope - Search Projects'
      },
      {
        "<leader>bf",
        function() vim.cmd.Telescope('file_browser') end,
        desc =
        'Telescope - Browse Folders'
      },
      {
        "<leader>bc",
        ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
        desc =
        'Telescope - Browse Current Folder'
      },
    },
    config = function()
      local telescope = require('telescope')

      telescope.load_extension("workspaces")
      telescope.load_extension("file_browser")
      telescope.load_extension("ui-select")

      telescope.setup({
        defaults = {
          path_display = { "filename_first" }
        },
        extensions = {
          workspaces = {
            keep_insert = true,
          },
          file_browser = {
            hijack_netrw = true,
          }
        }
      })
    end
  },
  {
      "natecraddock/workspaces.nvim",
      lazy = false,
      opts = {}
  },
  {
    'ThePrimeagen/harpoon',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    keys = {
      { "<leader>ha", function() require 'harpoon.mark'.add_file() end,        desc = 'Harpoon - Add File' },
      { "<leader>hl", function() require 'harpoon.ui'.toggle_quick_menu() end, desc = 'Harpoon - List Files' },
      { "<leader>h1", function() require 'harpoon.ui'.nav_file(1) end,         desc = 'Harpoon - Open File 1' },
      { "<leader>h2", function() require 'harpoon.ui'.nav_file(2) end,         desc = 'Harpoon - Open File 2' },
      { "<leader>h3", function() require 'harpoon.ui'.nav_file(3) end,         desc = 'Harpoon - Open File 3' },
      { "<leader>h4", function() require 'harpoon.ui'.nav_file(4) end,         desc = 'Harpoon - Open File 4' },
      { "<leader>h5", function() require 'harpoon.ui'.nav_file(5) end,         desc = 'Harpoon - Open File 5' }
    },
  },

  -- Source Control
  {
    "tpope/vim-fugitive",
    cmd = {
      'G',
      'Git',
      'Gread'
    },
  },
  {
    'mbbill/undotree',
    keys = {
      {
        "<leader>ut",
        ":UndotreeToggle<CR>",
        desc =
        'UndoTree - Toggle'
      },
    }
  },

  -- Appearance
  {
    'bluz71/nvim-linefly',
    config = function()
      vim.g.linefly_options = {
        with_attached_clients = false,
      }
    end
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = true
    }
  }
})

vim.cmd('colorscheme catppuccin')
