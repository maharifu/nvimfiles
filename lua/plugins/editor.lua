-- Editor behaviour plugins: motions, keymap discovery, diagnostics list, TODO
-- highlighting, alignment, surround, undo history, and smarter text objects.
return {
  -- flash.nvim: jump-anywhere motions + enhanced f/F/t/T. Replaces clever-f.vim.
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
    },
  },

  -- which-key: popup showing available keybindings as you start a chord. Great
  -- for discovering/learning the config (adopted from LazyVim).
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- trouble: a clean diagnostics / quickfix / references panel. Upgrade to the
  -- old ALE loclist navigation flow.
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<Leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<Leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics (Trouble)" },
      { "<Leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix (Trouble)" },
    },
  },

  -- todo-comments: highlight & search TODO/FIXME/HACK/etc.
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "<Leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todos (Trouble)" },
    },
  },

  -- mini.ai: smarter a/i text objects (brackets, quotes, arguments, tags) plus
  -- treesitter-backed af/if (function) and ac/ic (class). Adopted from LazyVim.
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    config = function()
      local ai = require("mini.ai")
      ai.setup({
        custom_textobjects = {
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        },
      })
    end,
  },

  -- vim-easy-align: kept from the old config. `ga` in visual mode or as a motion.
  {
    "junegunn/vim-easy-align",
    keys = {
      { "ga", "<Plug>(EasyAlign)", mode = { "n", "x" }, desc = "EasyAlign" },
    },
  },

  -- Surround: nvim-surround replaces tpope/vim-surround (same idea, native lua).
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- undotree: kept from the old config. <F4> toggles the undo history view.
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<F4>", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo tree" },
    },
  },

  -- Kept tpope plugins that work unchanged in nvim and have no better replacement.
  { "tpope/vim-rails", ft = { "ruby", "eruby", "haml", "slim" } },
  { "tpope/vim-abolish", event = "VeryLazy" }, -- :Subvert, coercion (crs/crc/...), abbreviations
}
