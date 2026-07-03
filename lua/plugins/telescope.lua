-- Telescope: fuzzy finder. Replaces the old denite.nvim stack (denite +
-- nvim-yarp + vim-hug-neovim-rpc + neomru). Keymaps mirror the old denite ones.
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- Native fzf sorter (compiled) for speed.
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      -- <C-p>: find files (was denite file/rec)
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      -- <C-f>: live grep across the project (was denite grep)
      { "<C-f>", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      -- <C-g>: grep the word under the cursor (was <C-g> cword grep)
      { "<C-g>", "<cmd>Telescope grep_string<cr>", desc = "Grep word under cursor" },
      -- <C-b>: switch buffers (was denite buffer)
      { "<C-b>", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    },
    opts = {
      defaults = {
        -- rg powers grep; mirror the old ignore globs from the denite config.
        file_ignore_patterns = {
          "%.git/", "%.ropeproject/", "__pycache__/", "venv/", "images/",
          "%.min%.", "img/", "fonts/", "node_modules/", "%.sass%-cache/", "vendor/",
        },
        mappings = {
          -- Keep arrow keys moving the selection in insert mode, as denite did.
          i = {
            ["<Down>"] = "move_selection_next",
            ["<Up>"] = "move_selection_previous",
          },
        },
      },
      pickers = {
        find_files = {
          -- rg --files honours .gitignore and is fast (was the denite rg setup).
          find_command = { "rg", "--files", "--glob", "!.git" },
        },
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
    end,
  },
}
