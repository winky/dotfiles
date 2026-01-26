-- indent-blankline.nvim: Indent guides using Neovim's virtual text
return {
  "lukas-reineke/indent-blankline.nvim",
  event = "VeryLazy",
  main = "ibl",
  config = function()
    require("ibl").setup({
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = {
        enabled = false, -- Disable scope visualization for now
      },
    })
  end,
}
