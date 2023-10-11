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

wk.register({
  ['<leader>x'] = {
    name = "+Trouble",
    x = {'<cmd>TroubleToggle<CR>', "Toggle"},
    w = {'<cmd>TroubleToggle workspace_diagnostics<CR>', "Workspace diagnostics"},
    d = {'<cmd>TroubleToggle document_diagnostics<CR>', "Document diagnostics"},
    q = {'<cmd>TroubleToggle quickfix<CR>', "Quickfix list"},
    l = {'<cmd>TroubleToggle loclist<CR>', "Location list"},
  },
  ['[x'] = {function() require('trouble').previous({skip_groups = true, jump = true}) end, 'Trouble previous'},
  [']x'] = {function() require('trouble').next({skip_groups = true, jump = true}) end, 'Trouble next'},

  ['<leader>f'] = {
    name = "+File",
    f = {'<cmd>Telescope find_files<CR>', "Find file"},
    g = {'<cmd>Telescope live_grep<CR>', "Live grep"},
    s = {'<cmd>Telescope lsp_dynamic_workspace_symbols<CR>', "Workspace symbols"},
  }
},  { noremap = true, silent = true, mode = "n" })
