-- nvim-lspconfig: Quickstart configurations for Neovim's built-in LSP client
-- Using Neovim 0.11+ native LSP API (vim.lsp.config)
return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- For LSP completion integration (already installed via nvim-cmp)
  },
  config = function()
    -- Using Neovim 0.11+ native LSP API (vim.lsp.config)
    -- This avoids the deprecated require('lspconfig') framework

    -- Global LSP settings
    local on_attach = function(client, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

      -- Mappings
      local opts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
      vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
      vim.keymap.set("n", "<Leader>wa", vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", opts, { desc = "Add workspace folder" }))
      vim.keymap.set("n", "<Leader>wr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, { desc = "Remove workspace folder" }))
      vim.keymap.set("n", "<Leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))
      vim.keymap.set("n", "<Leader>D", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Type definition" }))
      vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
      vim.keymap.set({ "n", "v" }, "<Leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
      vim.keymap.set("n", "<Leader>gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
      vim.keymap.set("n", "<Leader>f", function()
        vim.lsp.buf.format({ async = true })
      end, vim.tbl_extend("force", opts, { desc = "Format" }))
    end

    -- LSP capabilities (for nvim-cmp integration)
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Diagnostic configuration
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    -- Diagnostic signs
    local signs = { Error = "✗", Warn = "⚠", Hint = "➤", Info = "ℹ" }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    -- Language server configurations using Neovim 0.11+ native API
    -- Lua
    vim.lsp.config["lua_ls"] = {
      cmd = { "lua-language-server" },
      filetypes = { "lua" },
      root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
          telemetry = {
            enable = false,
          },
        },
      },
    }
    vim.lsp.enable("lua_ls")

    -- Python
    vim.lsp.config["pyright"] = {
      cmd = { "pyright-langserver", "--stdio" },
      filetypes = { "python" },
      root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "workspace",
          },
        },
      },
    }
    vim.lsp.enable("pyright")

    -- TypeScript/JavaScript
    vim.lsp.config["tsserver"] = {
      cmd = { "typescript-language-server", "--stdio" },
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        typescript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = false,
            includeInlayFunctionParameterTypeHints = true,
            includeInlayVariableTypeHints = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayEnumMemberValueHints = true,
          },
        },
      },
    }
    vim.lsp.enable("tsserver")

    -- Go
    vim.lsp.config["gopls"] = {
      cmd = { "gopls" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      root_markers = { "go.mod", "go.work", ".git" },
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
          },
          staticcheck = true,
          gofumpt = true,
        },
      },
    }
    vim.lsp.enable("gopls")

    -- PHP
    vim.lsp.config["intelephense"] = {
      cmd = { "intelephense", "--stdio" },
      filetypes = { "php" },
      root_markers = { "composer.json", ".git" },
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        intelephense = {
          files = {
            maxSize = 5000000,
          },
          diagnostics = {
            enable = true,
          },
        },
      },
    }
    vim.lsp.enable("intelephense")

    -- Auto-format on save (optional, can be enabled per filetype)
    -- vim.api.nvim_create_autocmd("BufWritePre", {
    --   pattern = { "*.lua", "*.py", "*.js", "*.ts" },
    --   callback = function()
    --     vim.lsp.buf.format({ async = false })
    --   end,
    -- })
  end,
}
