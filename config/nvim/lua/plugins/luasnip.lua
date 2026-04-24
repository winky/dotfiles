-- LuaSnip: Snippet Engine for Neovim written in Lua
return {
  "L3MON4D3/LuaSnip",
  event = "InsertEnter",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
    -- Key mappings for snippet navigation
    vim.keymap.set({ "i", "s" }, "<C-k>", function()
      if require("luasnip").expand_or_jumpable() then
        require("luasnip").expand_or_jump()
      end
    end, { silent = true })
    vim.keymap.set({ "i", "s" }, "<C-j>", function()
      if require("luasnip").jumpable(-1) then
        require("luasnip").jump(-1)
      end
    end, { silent = true })
  end,
}
