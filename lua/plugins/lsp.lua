-- LSP via nvim-lspconfig, using Neovim 0.11+'s native vim.lsp.config / enable.
-- Replaces ALE's LSP layer and vim-go's LSP features. Servers are the system
-- binaries already on PATH (no Mason): gopls, rust-analyzer, ts_ls, eslint,
-- terraformls. lazydev gives completion/docs for the nvim Lua API while editing
-- this very config.
return {
  -- lazydev: makes editing this Lua config pleasant (nvim API completion/docs).
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "saghen/blink.cmp" },
    config = function()
      -- Completion capabilities advertised to servers come from blink.cmp.
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      -- Per-server tweaks merge on top of lspconfig's shipped defaults.
      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            gofumpt = false,
            analyses = { unusedparams = true },
            staticcheck = true,
          },
        },
      })

      -- Enable the servers whose binaries exist on PATH. terraformls is only
      -- enabled when terraform is installed (it currently is not).
      local servers = { "gopls", "rust_analyzer", "ts_ls", "eslint" }
      if vim.fn.executable("terraform-ls") == 1 then
        table.insert(servers, "terraformls")
      end
      vim.lsp.enable(servers)

      -- Buffer-local keymaps once a server attaches. Neovim 0.11+ already sets
      -- some defaults (grn rename, gra code action, grr references, gri
      -- implementation, K hover, [d/]d diagnostics); these add/clarify a few.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(ev)
          local function map(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = desc })
          end
          map("gd", require("telescope.builtin").lsp_definitions, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("grr", require("telescope.builtin").lsp_references, "References")
          -- <Leader>i: implementations (was vim-go's :GoImplements).
          map("<Leader>i", require("telescope.builtin").lsp_implementations, "Implementations")
        end,
      })
    end,
  },
}
