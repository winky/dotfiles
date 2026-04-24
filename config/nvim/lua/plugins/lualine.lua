-- lualine.nvim: A blazing fast and easy to configure neovim statusline plugin
return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "VeryLazy",
  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "auto", -- Auto-detect theme
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { "mode", "paste" },
        lualine_b = { "readonly", "filename", "modified" },
        lualine_c = {},
        lualine_x = {},
        lualine_y = { "filetype" },
        lualine_z = { "location", "progress" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = { "filename" },
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "location" },
      },
      tabline = {
        lualine_a = { "tabs" },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "buffers" },
      },
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    })
  end,
}
