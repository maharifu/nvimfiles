-- Git integration.
--   * vim-fugitive: kept as-is from the old config (best-in-class Git wrapper,
--     works unchanged in nvim). Also covers merge-conflict resolution, replacing
--     vim-conflicted. gl/gu grab the local/upstream side in a 3-way diff, matching
--     the old conflicted diffget mappings.
--   * gitsigns: gutter signs + hunk staging/preview (new; complements fugitive).
--   * diffview: GitHub-style review UI (file panel + side-by-side diffs). The
--     <Leader>gd mapping diffs the branch against the merge-base with main, the
--     same set of changes you'd see in a PR's "Files changed" tab.
return {
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "Gblame" },
    keys = {
      { "gl", "<cmd>diffget //2<cr>", desc = "Conflict: take local (target) side" },
      { "gu", "<cmd>diffget //3<cr>", desc = "Conflict: take upstream (merge) side" },
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
    keys = {
      { "<Leader>gd", "<cmd>DiffviewOpen origin/main...HEAD<cr>", desc = "Diffview: review branch vs main (PR-style)" },
      { "<Leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: branch file history" },
      { "<Leader>gc", "<cmd>DiffviewClose<cr>", desc = "Diffview: close" },
    },
    opts = {},
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        map("n", "]h", gs.next_hunk, "Next git hunk")
        map("n", "[h", gs.prev_hunk, "Prev git hunk")
        map("n", "<Leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<Leader>hr", gs.reset_hunk, "Reset hunk")
        map("n", "<Leader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "<Leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
      end,
    },
  },
}
