-- Keep the molokai look from the old config. tomasr/molokai is the canonical
-- source of the scheme the old vimrc used. With termguicolors on it renders in
-- true color.
return {
  {
    "tomasr/molokai",
    lazy = false, -- load during startup
    priority = 1000, -- before other UI plugins so highlights are set early
    config = function()
      vim.cmd.colorscheme("molokai")
    end,
  },
}
