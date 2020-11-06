local diagnostic = require('diagnostic')
local completion = require('completion')
local nvim_lsp = require('nvim_lsp')
local configs = require('nvim_lsp/configs')
local util = require('nvim_lsp/util')

local on_attach = function(client, bufnr)
  diagnostic.on_attach(client, bufnr)
  completion.on_attach(client, bufnr)

  -- Keybindings for LSPs
  -- Note these are in on_attach so that they don't override bindings in a non-LSP setting
  vim.fn.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.implementation()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "<c-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "1gD", "<cmd>lua vim.lsp.buf.type_definition()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "g0", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", {noremap = true, silent = true})
  vim.fn.nvim_set_keymap("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>", {noremap = true, silent = true})
end

nvim_lsp.pyls_ms.setup{
  on_attach=on_attach;
  root_dir = function(fname)
    local filename = nvim_lsp.util.path.is_absolute(fname) and fname or nvim_lsp.util.path.join(vim.loop.cwd(), fname)
    local root_pattern = nvim_lsp.util.root_pattern('setup.py', 'setup.cfg', 'requirements.txt', 'mypy.ini', '.pylintrc', '.flake8rc', '.git', '.gitignore', 'Makefile')
    return root_pattern(filename) or nvim_lsp.util.path.dirname(filename)
  end
}

nvim_lsp.sumneko_lua.setup{
  on_attach = on_attach,
}

nvim_lsp.vimls.setup{
  on_attach = on_attach,
}

nvim_lsp.bashls.setup{
  on_attach = on_attach,
}
