-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  -- Dependencies
  { "nvim-lua/plenary.nvim" },
  { "MunifTanjim/nui.nvim" },

  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- UI Components
  { "nvim-tree/nvim-web-devicons" },
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require('lualine').setup()
    end,
  },
  {
    "akinsho/bufferline.nvim",
    config = function()
      vim.opt.termguicolors = true
      require("bufferline").setup()
    end,
  },
  { "rcarriga/nvim-notify" },
  {
    "folke/noice.nvim",
    config = function()
      require('noice').setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
      })
    end,
  },

  -- Neovim lua configuration
  { "folke/neodev.nvim" },

  -- LSP and Completion
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-buffer" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    config = function()
      require('copilot').setup({
        filetypes = {
          yaml = true,
          markdown = true,
        }
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    config = function()
      require('copilot_cmp').setup()
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("treesitter")
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects" },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      local trouble = require('trouble.sources.telescope')
      local builtin = require('telescope.builtin')

      -- Set up keybindings
      vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = "Find file" })
      vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set('n', '<leader>s', builtin.lsp_dynamic_workspace_symbols, { desc = "Workspace symbols" })

      require('telescope').setup{
        defaults = {
          mappings = {
            i = {
              ["<C-t>"] = trouble.open
            },
            n = {
              ["<C-t>"] = trouble.open
            },
          }
        }
      }
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require('telescope').load_extension('ui-select')
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
    config = function()
      require('telescope').load_extension('fzf')
    end,
  },

  -- Diagnostics
  {
    "folke/trouble.nvim",
    config = function()
      require('trouble').setup()
    end,
  },

  -- Navigation
  { "christoomey/vim-tmux-navigator" },

  -- Utilities
  {
    "kylechui/nvim-surround",
    config = function()
      require('nvim-surround').setup {}
    end,
  },
  {
    "johmsalas/text-case.nvim",
    config = function()
      require('textcase').setup {}
    end,
  },
  {
    "kosayoda/nvim-lightbulb",
    config = function()
      require('nvim-lightbulb').setup({autocmd = {enabled = true}})
    end,
  },
  {
    "folke/which-key.nvim",
    config = function()
      require('which-key').setup {}

      -- Register which-key mappings after lazy loads plugins
      require('which-key').add({
        { "<leader>f", group = "Find" },
        { "<leader>ff", function() require('telescope.builtin').find_files() end, desc = "Find file" },
        { "<leader>fg", function() require('telescope.builtin').live_grep() end, desc = "Live grep" },
        { "<leader>fs", function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end, desc = "Workspace symbols" },
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require('gitsigns').setup {
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          -- Actions
          map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
          map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
          map('n', '<leader>hS', gs.stage_buffer)
          map('n', '<leader>hu', gs.undo_stage_hunk)
          map('n', '<leader>hR', gs.reset_buffer)
          map('n', '<leader>hp', gs.preview_hunk)
          map('n', '<leader>hb', function() gs.blame_line{full=true} end)
          map('n', '<leader>tb', gs.toggle_current_line_blame)
          map('n', '<leader>hd', gs.diffthis)
          map('n', '<leader>hD', function() gs.diffthis('~') end)
          map('n', '<leader>td', gs.toggle_deleted)

          -- Text object
          map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
      }
    end,
  },

  -- Use v4.4.1
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    tag = "v4.4.1",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    config = function()
      require('CopilotChat').setup({})
    end,
  },
  {
    "ekickx/clipboard-image.nvim",
    config = function()
      require('clipboard-image').setup {
        default = {
          img_name = function ()
            vim.fn.inputsave()
            local name = vim.fn.input('Name: ')
            vim.fn.inputrestore()

            if name == nil or name == '' then
              return os.date('%y-%m-%d-%H-%M-%S')
            end
            return name
          end
        }
      }
    end,
  },

  -- Debuggers
  { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} },
  { "theHamsta/nvim-dap-virtual-text" },
}, {
  install = {
    colorscheme = { "tokyonight" }
  },
})
