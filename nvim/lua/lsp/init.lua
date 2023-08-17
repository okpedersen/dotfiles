local nvim_lsp = require('lspconfig')
local util = require('lspconfig/util')
local cmp = require('cmp')
local wk = require("which-key")

for i, v in ipairs(cmp.mapping) do print(i, v) end
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
});

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities());
local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local nOpts = { noremap = true, silent = true, mode = "n", buffer = bufnr}
  wk.register({
    g = {
      name = "+Go to",
      D = {'<Cmd>lua vim.lsp.buf.declaration()<CR>', "Declaration" },
      d = {'<Cmd>lua vim.lsp.buf.definition()<CR>', "Definition"},
      i = {'<cmd>lua vim.lsp.buf.implementation()<CR>', "Implementation"},
      r = {'<cmd>lua vim.lsp.buf.references()<CR>', "References"},
      R = {'<cmd>TroubleToggle lsp_references<CR>', "References (Trouble)"},
    },
    ['<leader>D'] = {'<cmd>lua vim.lsp.buf.type_definition()<CR>', "Go to type definiditon"},
    ['K'] = {'<Cmd>lua vim.lsp.buf.hover()<CR>', "Show documentation"},
    ['<C-s>'] = {'<cmd>lua vim.lsp.buf.signature_help()<CR>', "Signature help"},

    ['<leader>w'] = {
      name = "+Workspace",
      ['a'] = {'<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', "Add folder"},
      ['r'] = {'<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', "Remove folder"},
      ['l'] = {'<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', "List folder"},
    },

    ['<leader>rn'] = {'<cmd>lua vim.lsp.buf.rename()<CR>', "Rename"},
    ['<leader>ca'] = {'<cmd>lua vim.lsp.buf.code_action()<CR>', "Code action"},
    ['<leader>e'] = {'<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>', "Open line diagnostics float"},
    ['[d'] = {'<cmd>lua vim.diagnostic.goto_prev()<CR>', "Previous diagnostic"},
    [']d'] = {'<cmd>lua vim.diagnostic.goto_next()<CR>', "Next diagnostic"},
  }, nOpts)

  local vOpts = { noremap = true, silent = true, mode = "v", buffer = bufnr}
  wk.register({
    ['<leader>ca'] = {'<cmd>lua vim.lsp.buf.range_code_action()<CR>', "Code action"},
  }, vOpts)

  wk.register({
    ['<leader>x'] = {
      name = "+Trouble",
      x = {'<cmd>TroubleToggle<CR>', "Toggle"},
      w = {'<cmd>TroubleToggle workspace_diagnostics<CR>', "Workspace diagnostics"},
      d = {'<cmd>TroubleToggle document_diagnostics<CR>', "Document diagnostics"},
      q = {'<cmd>TroubleToggle quickfix<CR>', "Quickfix list"},
      l = {'<cmd>TroubleToggle loclist<CR>', "Location list"},
    },
    ['[x'] = {[[<cmd>lua require('trouble').previous({skip_groups = true, jump = true})<CR>]], "Trouble previous"},
    [']x'] = {[[<cmd>lua require('trouble').next({skip_groups = true, jump = true})<CR>]], "Trouble next"},
  }, nOpts)

  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

nvim_lsp.yamlls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    yaml = {
      schemastore = {
        enable = true
      }
    }
  }
}

nvim_lsp.terraformls.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "tf", "terraform" }
}

nvim_lsp.pyright.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  root_dir = function(fname)
    local filename = util.path.is_absolute(fname) and fname or util.path.join(vim.loop.cwd(), fname)
    local root_pattern = util.root_pattern('setup.py', 'setup.cfg', 'requirements.txt', 'mypy.ini', '.pylintrc',
      '.flake8rc', '.git', 'pyproject.toml')
    return root_pattern(filename) or util.path.dirname(filename)
  end
}

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require 'lspconfig'.sumneko_lua.setup {
  cmd = { "lua-language-server" },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

require 'lspconfig'.omnisharp.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
  root_dir = util.root_pattern("omnisharp.json", "*.sln")
}

local servers = { "vimls", "bashls", "tsserver", "rnix" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }
end
