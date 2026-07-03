# nvimfiles

A modern, hand-rolled Neovim config — built as a parallel modernization of my
Vim config (`~/.vim` / `repos/vimfiles`). The two are fully independent: Vim still
reads `~/.vim`, Neovim reads `~/.config/nvim` (a symlink to this repo).

## Layout

```
init.lua                  bootstrap + load order
lua/config/               options, keymaps, autocmds, lazy bootstrap
lua/plugins/              one file per concern (lsp, telescope, git, ...)
ftplugin/                 per-filetype settings (go, javascript)
after/ftplugin/           per-filetype overrides (tex spell)
```

Plugin manager is [lazy.nvim](https://github.com/folke/lazy.nvim) (the vim-plug
equivalent). Run `:Lazy` for the UI, `:Lazy sync` to install/update.

## What changed from the old Vim config

| Old (Vim) | New (Neovim) |
|-----------|--------------|
| vim-plug | lazy.nvim |
| denite (+ yarp/rpc/neomru) | telescope.nvim |
| ALE (LSP + fix + lint) | nvim-lspconfig + conform.nvim + nvim-lint |
| supertab | blink.cmp |
| vim-airline | lualine.nvim |
| nerdtree (+git) | neo-tree.nvim |
| syntax plugins (json/ts/css/docker/go/rust) | nvim-treesitter |
| clever-f | flash.nvim |
| vim-commentary | builtin `gc` |
| vim-surround | nvim-surround |
| matchit / indexed-search / vim-man / csapprox | nvim builtins |
| vim-conflicted | vim-fugitive (kept) + gitsigns |
| **kept** | vim-fugitive, vim-rails, vim-abolish, vim-easy-align, undotree |
| **dropped** | zeavim, vim-ginkgo, vim-autotag, vim-localrc, vim-dirdiff, vim-mustache-handlebars |
| **added (from LazyVim)** | which-key, lazydev, trouble, todo-comments, nvim-ts-autotag, mini.ai |

## Key mappings (carried over)

Leader is `\` (same as before).

| Key | Action |
|-----|--------|
| `<C-p>` | find files (telescope) |
| `<C-f>` | live grep |
| `<C-g>` | grep word under cursor |
| `<C-b>` | buffers |
| `<Leader>p` | toggle file tree (neo-tree) |
| `<F4>` | toggle undo tree |
| `<C-l>` | clear search highlight |
| `<C-j>` / `<C-k>` | next / prev diagnostic |
| `<C-w>E` | toggle diagnostics |
| `<Leader>i` | LSP implementations |
| `ga` | EasyAlign |
| `<Leader><Tab>` | new tab |
| `K` | LSP hover (`:Man` still works too) |
| `<C-w>h/j/k/l` | move between splits / tmux panes |
| `gl` / `gu` | take local / upstream side in a merge conflict |
| `:Bw` | wipe all buffers |
| `:W` | save as root (sudo) |

## New mappings worth knowing

| Key | Action |
|-----|--------|
| `gd` / `grr` / `gri` | go to definition / references / implementation |
| `grn` / `gra` | rename / code action (nvim 0.11+ defaults) |
| `s` / `S` | flash jump / flash treesitter |
| `<Leader>f` | format buffer (conform) |
| `]h` / `[h` | next / prev git hunk |
| `<Leader>hs/hr/hp/hb` | stage / reset / preview hunk, blame line |
| `<Leader>xx` / `<Leader>xt` | diagnostics / todos (trouble) |
| `af` `if` `ac` `ic` | function / class text objects (mini.ai) |

## Tooling

Uses system-installed binaries (no Mason): `gopls`, `rust-analyzer`, `ts_ls`,
`eslint`, `goimports`, `rustfmt`, `golangci-lint`, `rg`. Terraform/proto support
is wired but only activates when those tools are installed.

nvim-treesitter (on the `main` branch) compiles parsers with the `tree-sitter`
CLI, so it must be on `PATH` — install the binary, not the library (and not the
npm package). On Arch:

```
sudo pacman -S tree-sitter-cli
```

## Fonts (required for icons)

The file-type icons in neo-tree / telescope / lualine need Nerd Font glyphs.
Rather than the full patched font (`ttf-hack-nerd`), this setup keeps plain
**Hack** as the text font and pulls *only* the icon glyphs from the symbols-only
font via a fontconfig fallback. Reason: the patched `Hack Nerd Font Mono`
rewrites the vertical metrics (drops the line gap, lowers the ascender), so at a
given size its lines sit tighter/higher than plain Hack and look off. The
symbols-only font carries no Latin text, so it never touches line height.

On Arch (official repo):

```
sudo pacman -S ttf-nerd-fonts-symbols-mono
```

Then add the fallback (`~/.config/fontconfig/conf.d/10-hack-nerd-fallback.conf`):

```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <match target="pattern">
    <test name="family"><string>Hack</string></test>
    <edit name="family" mode="append" binding="weak">
      <string>Symbols Nerd Font Mono</string>
    </edit>
  </match>
</fontconfig>
```

Run `fc-cache -f`, set the terminal font to plain **`Hack`**, and restart the
terminal fully. Text uses Hack's original metrics; missing icon glyphs fall back
to `Symbols Nerd Font Mono`. The `Mono` symbols variant matches blink.cmp's
`nerd_font_variant = "mono"`, so completion icons stay single-width and aligned.

> Don't install `ttf-hack-nerd` — it's the full patched font this setup avoids.
