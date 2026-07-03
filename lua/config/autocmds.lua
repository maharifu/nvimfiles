-- Autocommands ported from the old vimrc.
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- Treat *.axlsx files as Ruby (they're Ruby DSL files).
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup,
  pattern = "*.axlsx",
  callback = function() vim.bo.filetype = "ruby" end,
})
