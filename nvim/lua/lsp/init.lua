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

  wk.add({
    remap = false, silent = true, mode = "n", buffer = bufnr,
    { 'g', group = "Go to", expand = function ()
      return {
        { 'D', vim.lsp.buf.declaration, desc = "Declaration" },
        { 'd', vim.lsp.buf.definition, desc = "Definition"},
        { 'i', vim.lsp.buf.implementation, desc = "Implementation"},
        { 'r', vim.lsp.buf.references, desc = "References"},
        { 'R', function() require('trouble').toggle({ mode = 'lsp_references' }) end, desc = "References (Trouble)"},
      }
      end
    },
    { '<leader>D', vim.lsp.buf.type_definition, desc = "Go to type definiton"},
    { 'K', vim.lsp.buf.hover, desc = "Show documentation"},
    { '<C-s>', vim.lsp.buf.signature_help, desc = "Signature help"},
    { '<leader>w', group = "Workspace", expand = function ()
      return {
        { 'a', vim.lsp.buf.add_workspace_folder, desc = "Add folder"},
        { 'r', vim.lsp.buf.remove_workspace_folder, desc = "Remove folder"},
        { 'l', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, desc = "List folder"},
      }
      end
    },
    { '<leader>rn', vim.lsp.buf.rename, desc = "Rename"},
    { '<leader>ca', vim.lsp.buf.code_action, desc = "Code action"},
    {'<leader>e', function() vim.diagnostic.open_float(0, {scope="line"}) end, desc = "Open line diagnostics float"},
    { '[d', vim.diagnostic.goto_prev, desc = "Previous diagnostic"},
    { ']d', vim.diagnostic.goto_next, desc = "Next diagnostic"},
  })

  wk.add({
    remap = false, silent = true, mode = "v", buffer = bufnr,
    { '<leader>ca', vim.lsp.buf.range_code_action, desc = "Code action"},
  })

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

require'lspconfig'.lua_ls.setup {
  on_init = function(client)
    local path = client.workspace_folders[1].name
    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
      return
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT'
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME
          -- Depending on the usage, you might want to add additional paths here.
          -- "${3rd}/luv/library"
          -- "${3rd}/busted/library",
        }
        -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
        -- library = vim.api.nvim_get_runtime_file("", true)
      }
    })
  end,
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {}
  }
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

local servers = { "vimls", "bashls", "tsserver", "nixd", "jsonnet_ls", "tinymist", "rust_analyzer" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    capabilities = capabilities,
    on_attach = on_attach,
  }
end
