-- Map leaders
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Use numbering, and reserve two columns for signs to avoid jumping
vim.opt.number = true
vim.opt.signcolumn = "yes:2"

-- Predictable splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Preferred defaults for spacing
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- search
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

vim.keymap.set('n', '<Leader>/', '<Cmd>nohls<CR>')

-- swap settings
vim.opt.updatetime = 300

-- cursorline settings
local ag_cursorline = vim.api.nvim_create_augroup("enable_cursorline", {})
vim.api.nvim_create_autocmd("BufEnter", {
  group = ag_cursorline,
  callback = function() vim.opt.cursorline = true end
})
vim.api.nvim_create_autocmd("BufLeave", {
  group = ag_cursorline,
  callback = function() vim.opt.cursorline = false end
})
