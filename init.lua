-- Neovim config (hand-rolled, modular). Independent from the Vim config in ~/.vim.
--
-- Load order:
--   1. core editor settings, keymaps, autocmds (work even with zero plugins)
--   2. lazy.nvim, which loads everything under lua/plugins/
--
-- Leader must be set before lazy.nvim / plugins load. Vim's default leader is
-- "\", which is what the old config used, so keep it.
vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
