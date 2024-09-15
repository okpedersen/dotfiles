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
  callback = function() vim.opt.cursorline = true end
})
vim.api.nvim_create_autocmd("BufLeave", {
  group = ag_cursorline,
  callback = function() vim.opt.cursorline = false end
})

local trouble = require('trouble')
local telescope = require('telescope.builtin')
wk.add({
  mode = 'n', remap = false, silent = true,
  { '<leader>x', group = "Trouble", expand = function ()
      return {
        { 'x', function () trouble.toggle({ mode = 'diagnostics' }) end, desc = "Diagnostics"},
        { 'd', function () trouble.toggle({ mode = 'diagnostics', filter = { buf = 0 } }) end, desc = "Diagnostics (document)"},
        { 'q', function () trouble.toggle({ mode = 'qflist' }) end, "Quickfix list"},
        { 'l', function () trouble.toggle({ mode = 'loclist' }) end, "Location list"},
      }
    end
  },
  { '[x', function() trouble.prev({skip_groups = true, jump = true}) end, desc = 'Trouble previous'},
  { ']x', function() trouble.next({skip_groups = true, jump = true}) end, desc = 'Trouble next'},
  { '<leader>f', group = "File", expand = function ()
      return {
        { 'f', function() telescope.find_files() end, desc = "Find file"},
        { 'g', function() telescope.live_grep() end, desc = "Live grep"},
        { 's', function() telescope.lsp_dynamic_workspace_symbols() end, desc = "Workspace symbols"},
      }
    end
  },
})
