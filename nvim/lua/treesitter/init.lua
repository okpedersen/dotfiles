local parser_install_dir = vim.fn.stdpath("data") .. "/treesitter"
vim.opt.runtimepath:prepend(parser_install_dir)
require'nvim-treesitter.configs'.setup {
  parser_install_dir = parser_install_dir,
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "go", "javascript", "typescript", "nix", "yaml", "json", "bash", "jsonnet", "java", "astro", "bicep", "c_sharp", "caddy", "comment", "cpp", "css", "csv", "cue", "diff", "dockerfile", "dot", "editorconfig", "fsharp", "git_config", "git_rebase", "gitcommit", "gitignore", "go", "gomod", "gosum", "gotmpl", "hcl", "helm", "html", "jq", "luadoc", "luap", "markdown", "markdown_inline", "nginx", "promql", "properties", "proto", "regex", "rego", "rst", "rust", "sql", "terraform", "tmux", "tsv", "tsx", "yaml" },
  auto_install = false,
  highlight = {
    enable = true
  }
}
