-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.relativenumber = true

-- Disable animations globally
vim.g.snacks_animate = false

-- Disable inlay hints
vim.lsp.inlay_hint.enable(false)
