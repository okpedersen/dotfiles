if not vim.g.vscode then
  local nvim_lsp = require('lspconfig')
  local configs = require('lspconfig/configs')
  local util = require('lspconfig/util')
  local cmp = require('cmp')

  for i, v in ipairs(cmp.mapping) do print(i, v) end
  cmp.setup({
    -- TODO: snippet
    mapping = {
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'buffer' },
    }
  });

  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities());

  nvim_lsp.yamlls.setup {
    capabilities = capabilities;
    settings = {
      yaml = {
        schemas = {
          kubernetes = "/**/*.yaml"
        }
      }
    }
  }

  nvim_lsp.terraformls.setup {
    capabilities = capabilities;
    filetypes = { "tf", "terraform" };
  }

  nvim_lsp.pyright.setup {
    capabilities = capabilities;
    root_dir = function(fname)
        local filename = util.path.is_absolute(fname) and fname or util.path.join(vim.loop.cwd(), fname)
        local root_pattern = util.root_pattern('setup.py', 'setup.cfg', 'requirements.txt', 'mypy.ini', '.pylintrc', '.flake8rc', '.git', 'pyproject.toml')
        return root_pattern(filename) or util.path.dirname(filename)
      end;
  }

  local servers = { "vimls", "bashls", "tsserver", "rnix" }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      capabilities = capabilities;
    }
  end
end
