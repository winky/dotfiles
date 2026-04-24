-- vim-go: Go development plugin
return {
  "fatih/vim-go",
  ft = "go",
  config = function()
    vim.g.go_highlight_functions = 1
    vim.g.go_highlight_methods = 1
    vim.g.go_highlight_structs = 1
    vim.g.go_highlight_interfaces = 1
    vim.g.go_highlight_operators = 1
    vim.g.go_highlight_extra_types = 1
    vim.g.go_highlight_build_constraints = 1
  end,
}
