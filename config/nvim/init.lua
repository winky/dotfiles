-- Neovim configuration with lazy.nvim
-- This file bootstraps lazy.nvim and loads plugin configurations

-- Set up leader keys before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Built-in features: trailing whitespace and substitute preview
-- Trailing whitespace highlighting
vim.o.list = true
vim.o.listchars = "tab:» ,lead:•,trail:•"
vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = "#ff6b6b" })
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    vim.cmd("syntax clear TrailingWhitespace")
    vim.cmd('syntax match TrailingWhitespace "\\_s\\+$"')
  end,
})

-- Substitute preview (replaces vim-over)
vim.o.inccommand = "nosplit"

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load lazy.nvim
require("lazy").setup("plugins", {
  defaults = {
    lazy = false,
  },
  install = {
    colorscheme = { "nightfox" },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})

-- Load existing vimrc for basic settings (encoding, display, keybindings, etc.)
-- Note: Plugin management is handled by lazy.nvim above
vim.cmd("source ~/.vimrc")
