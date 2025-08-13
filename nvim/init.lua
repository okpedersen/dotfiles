if not vim.g.vscode then
  require("lazy-bootstrap")
  require("config")
  require("lsp")
  require("treesitter")
  require("debugger")
end
