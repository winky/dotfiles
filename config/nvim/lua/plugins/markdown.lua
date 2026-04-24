-- Markdown support
return {
  { "plasticboy/vim-markdown", ft = "markdown" },
  {
    "kannokanno/previm",
    ft = "markdown",
    dependencies = { "tyru/open-browser.vim" },
    config = function()
      vim.g.vim_markdown_folding_disabled = 1
      vim.g.previm_show_header = 0
      vim.g.previm_custom_css_path = "~/.vim/templates/previm/markdown.css"
      vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
        pattern = "*.{md,mdwn,mkd,mkdn,mark*}",
        callback = function()
          vim.cmd("PrevimOpen")
        end,
      })
    end,
  },
  { "tyru/open-browser.vim", ft = "markdown" },
}
