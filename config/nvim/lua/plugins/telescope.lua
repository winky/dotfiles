-- telescope.nvim: Highly extendable fuzzy finder over lists
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = "Telescope",
  keys = {
    { "<C-c>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
  },
  config = function()
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<C-j>"] = require("telescope.actions").move_selection_next,
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
            ["<Esc>"] = require("telescope.actions").close,
          },
          n = {
            ["<Esc>"] = require("telescope.actions").close,
          },
        },
        file_ignore_patterns = {
          "%.git/",
          "node_modules/",
          "%.DS_Store",
        },
      },
      pickers = {
        find_files = {
          hidden = true, -- Show hidden files
        },
      },
    })
  end,
}
