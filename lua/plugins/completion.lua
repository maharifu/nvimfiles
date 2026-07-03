-- Completion engine. Replaces supertab. blink.cmp is fast, batteries-included
-- (sources + snippets + signature help) and integrates with the LSP capabilities
-- set in lsp.lua. <Tab>/<S-Tab> navigate, like the old supertab flow.
return {
  {
    "saghen/blink.cmp",
    event = "InsertEnter",
    version = "*", -- use a tagged release (ships prebuilt fuzzy matcher)
    opts = {
      keymap = {
        preset = "default", -- <C-y> accept, <C-n>/<C-p> or <C-j>/<C-k> select
        ["<Tab>"] = { "select_next", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
      appearance = { nerd_font_variant = "mono" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
      },
      signature = { enabled = true },
    },
  },
}
