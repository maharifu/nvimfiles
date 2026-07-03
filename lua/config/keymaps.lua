-- Global, plugin-independent keymaps and user commands, ported from the old
-- vimrc. Plugin-specific maps (telescope, LSP, neo-tree, undotree, easy-align,
-- flash, fugitive) live in their respective lua/plugins/ specs.
local map = vim.keymap.set

-- <C-l>: clear search highlight and redraw (normal + insert), as before.
map("n", "<C-l>", "<cmd>nohlsearch<bar>diffupdate<cr><C-l>", { silent = true })
map("i", "<C-l>", "<C-o><cmd>nohlsearch<cr>", { silent = true })

-- Open a new tab quickly (real tabs kept; no bufferline).
map("n", "<Leader><Tab>", "<cmd>tabnew<cr>", { silent = true })

-- Diagnostics navigation + toggle (replaces ALE's <C-j>/<C-k>/<C-w>E).
map("n", "<C-j>", function() vim.diagnostic.jump({ count = 1, float = true }) end,
  { silent = true, desc = "Next diagnostic" })
map("n", "<C-k>", function() vim.diagnostic.jump({ count = -1, float = true }) end,
  { silent = true, desc = "Prev diagnostic" })
map("n", "<C-w>E", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { silent = true, desc = "Toggle diagnostics" })
-- <Leader>e: show the full diagnostic message(s) for the current line in a float.
map("n", "<Leader>e", vim.diagnostic.open_float,
  { silent = true, desc = "Show diagnostic message" })

-- User commands ported from the old config.
-- :Bw  -> wipe all buffers
vim.api.nvim_create_user_command("Bw", "bufdo bw", {})
-- :W   -> save the current file as root via sudo+tee
vim.api.nvim_create_user_command("W", "w !sudo tee % > /dev/null", {})

-- tmux integration: seamless pane/window movement between Neovim splits and tmux
-- panes. Ported verbatim (in spirit) from the old TmuxMove() VimL function.
if vim.env.TMUX and vim.env.TMUX ~= "" then
  local function tmux_move(direction)
    local oldw = vim.fn.winnr()
    vim.cmd("silent! wincmd " .. direction)
    if oldw == vim.fn.winnr() then
      -- Already at an edge split: ask tmux to switch panes instead.
      local pane = ({ h = "L", j = "D", k = "U", l = "R" })[direction]
      vim.fn.system("tmux select-pane -" .. pane)
    end
  end
  for _, dir in ipairs({ "h", "j", "k", "l" }) do
    map("n", "<C-w>" .. dir, function() tmux_move(dir) end, { silent = true })
  end
  -- Direct <C-arrow> window/pane navigation (no <C-w> prefix needed).
  map("n", "<C-Left>", function() tmux_move("h") end, { silent = true })
  map("n", "<C-Down>", function() tmux_move("j") end, { silent = true })
  map("n", "<C-Up>", function() tmux_move("k") end, { silent = true })
  map("n", "<C-Right>", function() tmux_move("l") end, { silent = true })
  -- Keep the prefixed arrows too, for muscle memory.
  map("n", "<C-w><Left>", function() tmux_move("h") end, { silent = true })
  map("n", "<C-w><Down>", function() tmux_move("j") end, { silent = true })
  map("n", "<C-w><Up>", function() tmux_move("k") end, { silent = true })
  map("n", "<C-w><Right>", function() tmux_move("l") end, { silent = true })
else
  -- No tmux: plain split navigation with direct <C-arrow>.
  map("n", "<C-Left>", "<C-w>h", { silent = true })
  map("n", "<C-Down>", "<C-w>j", { silent = true })
  map("n", "<C-Up>", "<C-w>k", { silent = true })
  map("n", "<C-Right>", "<C-w>l", { silent = true })
end

-- Terminal-mode window navigation (e.g. leaving the Claude Code terminal split).
-- The <C-\><C-n> escape is consumed by Neovim, so it never reaches the embedded
-- program — switching away does NOT interrupt whatever is running there.
--
-- Alt+h/j/k/l only: modified *arrow* keys (Ctrl/Alt+Arrow) get their modifier
-- stripped in terminal mode when a TUI enables the kitty keyboard protocol, so they
-- can't be used here. Alt+letter arrives as a legacy ESC-prefixed byte that survives.
for lhs, dir in pairs({ ["<M-h>"] = "h", ["<M-j>"] = "j", ["<M-k>"] = "k", ["<M-l>"] = "l" }) do
  map("t", lhs, "<C-\\><C-n><C-w>" .. dir, { silent = true })
end
