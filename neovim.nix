{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    nerdfonts
    # Language servers for neovim
    nodePackages.vim-language-server
    nodePackages.bash-language-server
    nodePackages.pyright
    nodePackages.yaml-language-server
    nodePackages.typescript
    nodePackages.typescript-language-server
    terraform-ls
    rnix-lsp
    sumneko-lua-language-server
    omnisharp-roslyn

    # Debuggers
    netcoredbg
  ];

  programs.neovim = {
    enable = true;
    withNodeJs = true;
    withPython3 = true;
    extraPython3Packages = (ps: with ps; [ ]);
    plugins = with pkgs.myVimPlugins; with pkgs.vimPlugins; [
      # Dependencies used by other plugins
      plenary-nvim
      nui-nvim

      # Visual config/colorscheme
      {
        plugin = tokyonight;
        config = ''
          colorscheme tokyonight
        '';
      }
      nvim-web-devicons
      {
        plugin = lualine-nvim;
        config = ''
          lua require('lualine').setup()
        '';
      }
      {
        plugin = bufferline-nvim;
        config = ''
          lua <<EOF
            vim.opt.termguicolors = true
            require("bufferline").setup()
          EOF
        '';
      }
      nvim-notify
      {
        plugin = noice-nvim;
        config = ''
          lua <<EOF
            require('noice').setup({
              lsp = {
                override = {
                  ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                  ["vim.lsp.util.stylize_markdown"] = true,
                  ["cmp.entry.get_documentation"] = true,
                },

                -- TODO: Update nixpkgs for this to work
                --presets = {
                --  lsp_doc_border = true,
                --},
              },
            })
          EOF
        '';
      }
      # TODO: Arg highlighting: https://github.com/m-demare/hlargs.nvim
      # TODO: Extra plugins
      # - https://github.com/Chaitanyabsprip/present.nvim
      # - https://github.com/folke/twilight.nvim
      # - https://github.com/folke/zen-mode.nvim
      # - https://github.com/goolord/alpha-nvim

      # Neovim lua configuration
      neodev-nvim

      # LSP
      nvim-lspconfig
      cmp-nvim-lsp
      nvim-cmp
      cmp-buffer
      luasnip
      cmp_luasnip

      nvim-treesitter.withAllGrammars # TODO: Might be excessive to install all, but convenient
      nvim-treesitter-textobjects

      # Telescope
      telescope-nvim
      {
        plugin = telescope-ui-select-nvim;
        config = ''
          lua require('telescope').load_extension('ui-select');
        '';
      }
      {
        plugin = telescope-fzf-native-nvim;
        config = ''
          	        lua require('telescope').load_extension('fzf')
        '';
      }

      # Diagnostics
      trouble-nvim

      # Navigation
      tmux-navigator

      # Utilities
      {
        plugin = nvim-surround;
        config = ''
          lua require('nvim-surround').setup {}
        '';
      }
      {
        plugin = text-case-nvim;
        # TODO: consider Telescope integration
        config = ''
          lua require('textcase').setup {}
        '';
      }
      # TODO: https://github.com/smjonas/inc-rename.nvim
      # Test compatability with text-case
      {
        plugin = nvim-lightbulb;
        config = ''
          lua require('nvim-lightbulb').setup({autocmd = {enabled = true}})
        '';
      }
      {
        plugin = which-key-nvim;
        config = ''
          lua require('which-key').setup {}
        '';
      }
      {
        plugin = gitsigns-nvim;
        # TODO: Copy paste from gitsigns, move/change?
        config = ''
          lua <<EOF
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
          EOF
        '';
      }
      # TODO: https://github.com/Shatur/neovim-session-manager

      # Debuggers
      nvim-dap
      { plugin = nvim-dap-ui; config = ''''; }
      { plugin = nvim-dap-virtual-text; config = ''''; }
      # TODO: telescope-dap-nvim ?
      # TODO: cmp-dap ?

      /*
        # tpope plugins
        vim-repeat
        vim-unimpaired
        vim-fugitive
        vim-eunuch

        {
        plugin = delimitMate;
        config = ''
        let g:delimitMate_expand_cr = 1
        let g:delimitMate_expand_space = 0
        let g:delimitMate_smart_matchpairs = 1
        let g:delimitMate_balance_matchpairs = 1
        '';
        }

        {
        plugin = nerdtree;
        config = ''
        let NERDTreeShowHidden=1
        let NERDTreeQuitOnOpen=1
        map <Leader>n :NERDTreeFind<CR>
        '';
        }

        vim-nix
      */
    ];
    extraConfig = ''
      lua <<EOF
      if not vim.g.vscode then
        require("lsp")
        require("config")
        require("treesitter")
        require("debugger")
      end
      EOF
    '';
  };

  xdg.configFile."nvim/openapi-v3.0-draft-07.json".source = ./nvim/openapi-v3.0-draft-07.json;
  xdg.configFile."nvim/lua".source = ./nvim/lua;
}
