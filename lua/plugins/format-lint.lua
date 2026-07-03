-- Formatting (conform.nvim) and linting (nvim-lint), replacing ALE's fix/lint
-- layer. Mirrors the old config's behaviour exactly:
--   * format-on-save for Go (goimports), Rust (rustfmt), Terraform (terraform fmt)
--     — matching ale_fixers={go:goimports}, rust.vim rustfmt_autosave,
--       vim-terraform fmt_on_save. JS was NOT auto-fixed before, so it isn't here.
--   * linters: golangci-lint for Go, protolint for proto (eslint linting for JS
--     is handled by the eslint LSP in lsp.lua).
return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<Leader>f",
        function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        go = { "goimports" },
        rust = { "rustfmt" },
        terraform = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
      },
      format_on_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        local enabled = { go = true, rust = true, terraform = true, hcl = true }
        if not enabled[ft] then return end
        return { timeout_ms = 2000, lsp_format = "fallback" }
      end,
    },
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost", "InsertLeave" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        go = { "golangcilint" },
        proto = { "protolint" },
      }
      local grp = vim.api.nvim_create_augroup("UserNvimLint", { clear = true })
      vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
        group = grp,
        callback = function()
          -- Only run linters whose executable is actually installed.
          local names = lint.linters_by_ft[vim.bo.filetype] or {}
          local runnable = {}
          for _, name in ipairs(names) do
            local linter = lint.linters[name]
            local cmd = type(linter) == "table" and linter.cmd or nil
            if cmd and vim.fn.executable(cmd) == 1 then
              table.insert(runnable, name)
            end
          end
          if #runnable > 0 then lint.try_lint(runnable) end
        end,
      })
    end,
  },
}
