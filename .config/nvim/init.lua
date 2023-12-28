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

vim.g.mapleader = " ";

vim.opt.guicursor = "";
vim.opt.number = true;
vim.opt.relativenumber = true;
vim.opt.wrap = false;
vim.opt.shiftwidth = 2;

require("lazy").setup({
    { 
      'rose-pine/neovim', 
      name = 'rose-pine',
      priority = 1000,
      lazy = false,
      config = function() 
	vim.cmd('colorscheme rose-pine')
      end
    }
}, opts)
