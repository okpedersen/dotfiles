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
    { name = 'copilot' },
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
      D = {vim.lsp.buf.declaration, "Declaration" },
      d = {vim.lsp.buf.definition, "Definition"},
      i = {vim.lsp.buf.implementation, "Implementation"},
      r = {vim.lsp.buf.references, "References"},
      R = {'<cmd>TroubleToggle lsp_references<CR>', "References (Trouble)"},
    },
    ['<leader>D'] = {vim.lsp.buf.type_definition, "Go to type definiditon"},
    ['K'] = {vim.lsp.buf.hover, "Show documentation"},
    ['<C-s>'] = {vim.lsp.buf.signature_help, "Signature help"},

    ['<leader>w'] = {
      name = "+Workspace",
      ['a'] = {vim.lsp.buf.add_workspace_folder, "Add folder"},
      ['r'] = {vim.lsp.buf.remove_workspace_folder, "Remove folder"},
      ['l'] = {function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, "List folder"},
    },

    ['<leader>rn'] = {vim.lsp.buf.rename, "Rename"},
    ['<leader>ca'] = {vim.lsp.buf.code_action, "Code action"},
    ['<leader>e'] = {function() vim.diagnostic.open_float(0, {scope="line"}) end, "Open line diagnostics float"},
    ['[d'] = {vim.diagnostic.goto_prev, "Previous diagnostic"},
    [']d'] = {vim.diagnostic.goto_next, "Next diagnostic"},
  }, nOpts)

  local vOpts = { noremap = true, silent = true, mode = "v", buffer = bufnr}
  wk.register({
    ['<leader>ca'] = {vim.lsp.buf.range_code_action, "Code action"},
  }, vOpts)

wk.register({
  ['<leader>x'] = {
    name = '+Trouble',
    x = {'<cmd>TroubleToggle<CR>', 'Toggle'},
    w = {'<cmd>TroubleToggle workspace_diagnostics<CR>', 'Workspace diagnostics'},
    d = {'<cmd>TroubleToggle document_diagnostics<CR>', 'Document diagnostics'},
    q = {'<cmd>TroubleToggle quickfix<CR>', 'Quickfix list'},
    l = {'<cmd>TroubleToggle loclist<CR>', 'Location list'},
  },
  ['[x'] = {function() require('trouble').prev({skip_groups = true, jump = true}) end, 'Trouble previous'},
  [']x'] = {function() require('trouble').next({skip_groups = true, jump = true}) end, 'Trouble next'},
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
      },
      schemas = {
        [vim.fn.stdpath('config').."/openapi-v3.0-draft-07.json"] = "openapi.yaml"
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

require 'lspconfig'.gopls.setup {
  cmd = {'gopls'},
	-- for postfix snippets and analyzers
	capabilities = capabilities,
	    settings = {
	      gopls = {
		      experimentalPostfixCompletions = true,
		      analyses = {
		        unusedparams = true,
		        shadow = true,
		     },
		     staticcheck = true,
		    },
	    },
	on_attach = on_attach,
}

require 'lspconfig'.omnisharp.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
  root_dir = util.root_pattern("omnisharp.json", "*.sln")
}

local servers = { "vimls", "bashls", "tsserver", "nixd", "jsonnet_ls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }
end
