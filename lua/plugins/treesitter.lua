-- Treesitter: accurate syntax highlighting, indentation, and structural text
-- objects. Replaces vim-json, typescript-vim, vim-css3-syntax, Dockerfile.vim,
-- and the highlight-flag plugins from vim-go / rust.vim.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- The `main` branch. The old `master` branch is frozen and explicitly does
    -- NOT support Neovim 0.12+ (its custom query directives crash on the 0.11+
    -- `TSNode[]` match API — e.g. markdown code-block injections). `main` is the
    -- rewrite Neovim 0.12 expects: highlighting/indentation are driven by core
    -- and opted into per buffer rather than configured through a module.
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    -- Movement text objects (]f/[f, ]c/[c) live on the textobjects `main`
    -- branch; its queries also back mini.ai's af/if & ac/ic (see editor.lua),
    -- so it must be loaded for those to resolve.
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
    config = function()
      require("nvim-treesitter").setup()

      -- Equivalent of the old `ensure_installed`. install() is async and a
      -- no-op when a parser is already present; on the very first launch after
      -- this migration the parsers compile in the background, so highlighting
      -- only appears once that finishes (re-open the file or restart).
      require("nvim-treesitter").install({
        "bash", "c", "css", "dockerfile", "go", "gomod", "gosum", "gowork",
        "hcl", "html", "javascript", "json", "lua", "luadoc", "markdown",
        "markdown_inline", "proto", "python", "ruby", "rust", "terraform",
        "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
      })

      -- Highlighting and indentation are no longer automatic — Neovim drives
      -- them and we opt in per buffer. Enable both for any filetype that has a
      -- parser installed; vim.treesitter.start() errors (caught here) when none
      -- exists, so other filetypes are left untouched.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("nvim_treesitter_enable", { clear = true }),
        callback = function(ev)
          if pcall(vim.treesitter.start) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      -- Treesitter-based *movement* between functions/classes. Selection text
      -- objects (af/if, ac/ic) are provided by mini.ai (see editor.lua) so they
      -- share one consistent set of keys.
      require("nvim-treesitter-textobjects").setup({ move = { set_jumps = true } })
      local move = require("nvim-treesitter-textobjects.move")
      local function goto_map(lhs, fn, query, desc)
        vim.keymap.set({ "n", "x", "o" }, lhs, function() fn(query, "textobjects") end, { desc = desc })
      end
      goto_map("]f", move.goto_next_start, "@function.outer", "Next function")
      goto_map("]c", move.goto_next_start, "@class.outer", "Next class")
      goto_map("[f", move.goto_previous_start, "@function.outer", "Previous function")
      goto_map("[c", move.goto_previous_start, "@class.outer", "Previous class")
    end,
  },

  -- Auto-close / rename HTML, JSX, and handlebars tags.
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascriptreact", "typescriptreact", "vue", "svelte", "handlebars", "xml" },
    opts = {},
  },
}
