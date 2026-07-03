-- Bootstrap lazy.nvim (the plugin manager, like vim-plug in the old config).
-- Clones lazy.nvim on first launch, then loads every spec under lua/plugins/.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  -- Keep the molokai look; don't let lazy install/enable a different scheme.
  install = { colorscheme = { "molokai" } },
  checker = { enabled = false }, -- don't auto-check for plugin updates on startup
  change_detection = { notify = false },
})
