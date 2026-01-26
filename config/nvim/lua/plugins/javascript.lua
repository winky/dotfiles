-- JavaScript syntax support
return {
  { "pangloss/vim-javascript", ft = { "javascript", "javascript.jsx" } },
  { "othree/yajs.vim", ft = "javascript" },
  config = function()
    vim.g.javascript_plugin_jsdoc = 1
  end,
}
