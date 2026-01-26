-- Comment.nvim: Smart and powerful comment plugin for neovim
return {
  "numToStr/Comment.nvim",
  event = "VeryLazy",
  config = function()
    local comment = require("Comment")
    comment.setup({
      -- Add a space b/w comment and the line
      padding = true,
      -- Whether the cursor should stay at its position
      sticky = true,
      -- Lines to be ignored while (un)comment
      ignore = "^$",
      -- LHS of toggle mappings in NORMAL mode
      toggler = {
        line = "gcc", -- Line-comment toggle keymap
        block = "gbc", -- Block-comment toggle keymap
      },
      -- LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
        line = "gc", -- Line-comment operator keymap
        block = "gb", -- Block-comment operator keymap
      },
      -- LHS of extra mappings
      extra = {
        above = "gcO", -- Add comment on the line above
        below = "gco", -- Add comment on the line below
        eol = "gcA", -- Add comment at the end of line
      },
    })

    -- Map <Leader>c to toggle comment (matching caw.vim behavior)
    -- In normal mode: toggle current line
    -- In visual mode: toggle selected lines
    vim.keymap.set("n", "<Leader>c", "gcc", { desc = "Toggle comment", remap = true })
    vim.keymap.set("v", "<Leader>c", "gc", { desc = "Toggle comment", remap = true })
  end,
}
