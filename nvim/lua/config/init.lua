local wk = require("which-key")

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
  callback = function()
    vim.schedule(function()
      vim.opt.cursorline = true
    end)
  end
})
vim.api.nvim_create_autocmd("BufLeave", {
  group = ag_cursorline,
  callback = function()
    vim.schedule(function()
      vim.opt.cursorline = false
    end)
  end
})

-- Key mappings that don't require plugins loaded yet
vim.keymap.set('n', '<Leader>/', '<Cmd>nohls<CR>')

-- Register which-key mappings after lazy loads plugins
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local trouble = require('trouble')
    wk.add({
      mode = 'n', remap = false, silent = true,
      { '<leader>x', group = "Trouble" },
      { '<leader>xx', function () trouble.toggle({ mode = 'diagnostics' }) end, desc = "Diagnostics"},
      { '<leader>xd', function () trouble.toggle({ mode = 'diagnostics', filter = { buf = 0 } }) end, desc = "Diagnostics (document)"},
      { '<leader>xq', function () trouble.toggle({ mode = 'qflist' }) end, desc = "Quickfix list"},
      { '<leader>xl', function () trouble.toggle({ mode = 'loclist' }) end, desc = "Location list"},
      { '[x', function() trouble.prev({skip_groups = true, jump = true}) end, desc = 'Trouble previous'},
      { ']x', function() trouble.next({skip_groups = true, jump = true}) end, desc = 'Trouble next'},
    })
  end
})
