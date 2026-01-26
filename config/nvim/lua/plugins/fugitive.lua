-- vim-fugitive: Git wrapper for Vim
return {
  "tpope/vim-fugitive",
  cmd = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GBrowse", "GRemove", "GRename", "Glgrep", "Gedit" },
  keys = {
    { "<C-b>", ":Gblame<CR>", desc = "Show git blame" },
  },
}
