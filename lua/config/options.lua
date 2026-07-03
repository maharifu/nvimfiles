-- Editor options, ported from the old vimrc. Neovim already defaults many of the
-- old `set` lines on (nocompatible, incsearch, hlsearch, backspace, syntax,
-- filetype plugin/indent, wildmenu, autoindent...), so those are omitted.
local opt = vim.opt

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
-- Neovim hides the "[1/5]" search count by default; the old config used
-- vim-indexed-search for this. Re-enable the builtin count instead.
opt.shortmess:remove("S")

-- UI / display
opt.number = true
opt.showbreak = "..."
opt.wrap = true
opt.linebreak = true
opt.list = false
opt.termguicolors = true -- true color (replaces the old t_Co/csapprox dance)
opt.signcolumn = "yes" -- stable gutter so diagnostics/git signs don't shift text
opt.laststatus = 2 -- always show the status line (lualine)

-- 80-column marker (old config: textwidth=80 + colorcolumn=+1)
opt.textwidth = 80
opt.colorcolumn = "+1"

-- Indentation (2-space soft tabs by default; Go/JS overridden in ftplugin/)
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.autoindent = true

-- Folding (indent-based, open by default, max 3 levels deep)
opt.foldmethod = "indent"
opt.foldnestmax = 3
opt.foldenable = false

-- Command-line completion (bash-like) and ignores
opt.wildmode = { "list:longest" }
opt.wildignore = { "*.o", "*.obj", "*~", "*.pyc" }

-- Misc
opt.history = 1000
opt.synmaxcol = 200 -- perf: stop syntax highlighting very long lines
opt.modeline = false
opt.completeopt = { "menu", "menuone", "noselect" }

-- Persistent undo "since forever". Use a nvim-specific dir so it stays fully
-- independent from the Vim config's ~/.vim.undo.
local undodir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(undodir, "p")
opt.undofile = true
opt.undodir = undodir
