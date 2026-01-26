-- nvim-lint: An asynchronous linter plugin for Neovim
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Configure linters
    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      python = { "pylint", "flake8" },
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      zsh = { "shellcheck" },
      json = { "jsonlint" },
      yaml = { "yamllint" },
      markdown = { "markdownlint" },
      -- Add more as needed
    }

    -- Auto-run linters on save and when entering buffer
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    -- Manual lint command
    vim.api.nvim_create_user_command("Lint", function()
      lint.try_lint()
    end, { desc = "Run linter" })
  end,
}
