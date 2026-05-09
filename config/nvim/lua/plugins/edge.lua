-- edge: cross-editor colorscheme (also configured for Vim via dein in .vim/rc/dein.toml)
return {
  "sainnhe/edge",
  lazy = false,
  priority = 1000,
  config = function()
    vim.o.termguicolors = true
    vim.o.background = "dark"
    vim.g.edge_style = "aura"
    vim.g.edge_better_performance = 1
    vim.cmd("colorscheme edge")
  end,
}
