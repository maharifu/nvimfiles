-- File explorer. Replaces nerdtree + nerdtree-git-plugin (git status is built
-- into neo-tree). <Leader>p toggles it, matching the old NERDTreeToggle map.
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<Leader>p", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
    },
    opts = {
      filesystem = {
        filtered_items = {
          hide_by_pattern = { "*.o", "*~", "*.pyc" }, -- old NERDTreeIgnore
        },
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
    },
  },
}
