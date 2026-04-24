-- nvim-tree.lua: A file explorer tree for neovim written in lua
return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeFocus", "NvimTreeFindFile" },
  keys = {
    { "<C-e>", ":NvimTreeToggle<CR>", desc = "Toggle file tree" },
  },
  config = function()
    -- Disable netrw (nvim-tree handles file browsing)
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup({
      view = {
        width = 30,
        side = "left",
        preserve_window_proportions = false,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
      },
      renderer = {
        root_folder_label = ":~:s?$?/..?",
        indent_markers = {
          enable = true,
        },
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
        },
      },
      filters = {
        dotfiles = false, -- Show hidden files (equivalent to NERDTreeShowHidden = 1)
        custom = { ".DS_Store" }, -- Ignore .DS_Store (equivalent to NERDTreeIgnore)
        exclude = {}, -- Additional files to ignore
      },
      git = {
        enable = true,
        ignore = true,
        show_on_dirs = true,
        timeout = 400,
      },
      actions = {
        open_file = {
          quit_on_open = true, -- Close tree when opening a file (equivalent to NERDTreeQuitOnOpen = 1)
          window_picker = {
            enable = false,
          },
        },
      },
      update_focused_file = {
        enable = true,
        update_root = false,
      },
    })
  end,
}
