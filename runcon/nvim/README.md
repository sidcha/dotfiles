# Neovim Configuration - Custom Keybindings

This document lists all custom keybindings in this Neovim configuration.

**Leader Key**: `<Space>`

**Note**: Press `<Space>` in normal mode to see a which-key popup with all available keybindings!

---

## Table of Contents

- [Leader Key Bindings](#leader-key-bindings)
  - [Fuzzy Finding (FZF)](#fuzzy-finding-fzf)
  - [LSP (Language Server Protocol)](#lsp-language-server-protocol)
  - [Diagnostics](#diagnostics)
  - [Git](#git)
- [Backslash Bindings](#backslash-bindings)
- [Function Keys](#function-keys)
- [Navigation](#navigation)
  - [Basic Movement](#basic-movement)
  - [Diagnostic Navigation](#diagnostic-navigation)
  - [Git Navigation](#git-navigation)
  - [Function/Class Navigation](#functionclass-navigation-treesitter)
- [Buffer Management](#buffer-management)
- [File Explorer](#file-explorer)
- [Editing](#editing)
- [Visual Mode](#visual-mode)
- [Custom Commands](#custom-commands)
- [Linux Kernel Development](#linux-kernel-development)
- [Diff Mode](#diff-mode)

---

## Leader Key Bindings

### Fuzzy Finding (FZF)

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>g` | `:GFiles` | Search git files |
| `<leader>f` | `:Files` | Search all files |
| `<leader>t` | `:BTags` | Search tags in current buffer |
| `<leader>T` | `:Tags` | Search tags in directory |
| `<leader>b` | `:Buffers` | Search open buffers |
| `<leader>c` | `:BCommits` | Search commits for current file |
| `<leader>C` | `:Commits` | Search all commits |
| `<leader>/` | `:Rg` | Search pattern in files (ripgrep) |
| `<leader>h` | `:History` | Search recently opened files |

### LSP (Language Server Protocol)

These bindings are available when an LSP server is attached to the buffer.

| Key | Action | Description |
|-----|--------|-------------|
| `gd` | Go to definition | Jump to definition |
| `gD` | Go to declaration | Jump to declaration |
| `gr` | Find references | List all references |
| `gI` | Go to implementation | Jump to implementation |
| `K` | Hover documentation | Show documentation |
| `<C-k>` | Signature help | Show function signature |
| `<leader>D` | Type definition | Show type definition |
| `<leader>rn` | Rename symbol | Rename under cursor |
| `<leader>ca` | Code action | Show code actions |
| `<leader>ds` | Document symbols | List symbols in file |
| `<leader>ws` | Workspace symbols | List symbols in workspace |
| `<leader>wa` | Add workspace folder | Add folder to workspace |
| `<leader>wr` | Remove workspace folder | Remove folder from workspace |
| `<leader>wl` | List workspace folders | Show workspace folders |

### Diagnostics

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>e` | Open diagnostic float | Show error in floating window |
| `<leader>q` | Diagnostic quickfix | Open diagnostics in quickfix list |
| `[d` | Previous diagnostic | Jump to previous error |
| `]d` | Next diagnostic | Jump to next error |

### Git

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>hp` | Preview hunk | Preview git hunk changes |
| `[c` | Previous change | Jump to previous git change |
| `]c` | Next change | Jump to next git change |

### Treesitter (Code Actions)

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>a` | Swap next parameter | Swap with next function parameter |
| `<leader>A` | Swap previous parameter | Swap with previous function parameter |

---

## Backslash Bindings

Buffer and file tree management:

| Key | Action | Description |
|-----|--------|-------------|
| `\[` | Previous buffer | Switch to previous buffer |
| `\]` | Next buffer | Switch to next buffer |
| `\q` | Close buffer | Close current buffer, go to previous |
| `\o` | Close other buffers | Close all buffers except current |
| `\t` | Toggle file tree | Open/close NvimTree file explorer |

---

## Function Keys

| Key | Action | Description |
|-----|--------|-------------|
| `<F2>` | Trim whitespace | Remove trailing whitespace from file |
| `<F3>` | Toggle line numbers | Toggle line numbers and relative numbers |
| `<F4>` | Toggle wrap | Toggle line wrapping |
| `<F5>` | Toggle spell check | Toggle spell checking |
| `<F6>` | Git blame | Show git blame |

---

## Navigation

### Basic Movement

| Key | Action | Description |
|-----|--------|-------------|
| `j` / `k` | Move down/up | Respects word wrap (gj/gk) |
| `gm` | Go to middle | Jump to middle of current line |
| `<PageUp>` | Half page up | Same as `<C-u>` |
| `<PageDown>` | Half page down | Same as `<C-d>` |
| `<S-Up>` | Up | Remap shift+up to normal up |
| `<S-Down>` | Down | Remap shift+down to normal down |

### Diagnostic Navigation

| Key | Action | Description |
|-----|--------|-------------|
| `[d` | Previous diagnostic | Jump to previous error/warning |
| `]d` | Next diagnostic | Jump to next error/warning |

### Git Navigation

| Key | Action | Description |
|-----|--------|-------------|
| `[c` | Previous change | Jump to previous git hunk |
| `]c` | Next change | Jump to next git hunk |

### Function/Class Navigation (Treesitter)

| Key | Action | Description |
|-----|--------|-------------|
| `]m` | Next function start | Jump to next function |
| `[m` | Previous function start | Jump to previous function |
| `]M` | Next function end | Jump to end of next function |
| `[M` | Previous function end | Jump to end of previous function |
| `]]` | Next class start | Jump to next class |
| `[[` | Previous class start | Jump to previous class |
| `][` | Next class end | Jump to end of next class |
| `[]` | Previous class end | Jump to end of previous class |

---

## Buffer Management

| Key | Action | Description |
|-----|--------|-------------|
| `\[` | Previous buffer | Go to previous buffer |
| `\]` | Next buffer | Go to next buffer |
| `\q` | Close buffer | Close current buffer |
| `\o` | Close other buffers | Close all except current |

---

## File Explorer

| Key | Action | Description |
|-----|--------|-------------|
| `\t` | Toggle NvimTree | Open/close file tree |

In NvimTree:
- `<Enter>` - Open file
- `<C-v>` - Open in vertical split
- `<C-x>` - Open in horizontal split
- `<C-t>` - Open in new tab
- `a` - Create new file/directory
- `d` - Delete file/directory
- `r` - Rename file/directory
- `y` - Copy file name
- `Y` - Copy relative path
- `gy` - Copy absolute path

---

## Editing

| Key | Action | Description |
|-----|--------|-------------|
| `<F2>` | Trim whitespace | Remove trailing whitespace |
| `<C-q>` | Visual block mode | Start visual block selection (normally `<C-v>`) |
| `gc` | Comment toggle | Toggle comment (line or visual selection) |
| `gcc` | Comment line | Comment/uncomment current line |

### Increment Selection (Treesitter)

| Key | Action | Description |
|-----|--------|-------------|
| `<C-Space>` | Increment selection | Expand selection to next syntax node |
| `<C-s>` | Scope increment | Expand to scope |
| `<M-Space>` | Decrement selection | Shrink selection |

---

## Visual Mode

| Key | Action | Description |
|-----|--------|-------------|
| `<Space>` | No operation | Disabled to avoid conflicts |
| `j` / `k` | Move down/up | Respects word wrap |
| `<PageUp>` | Half page up | Same as `<C-u>` |
| `<PageDown>` | Half page down | Same as `<C-d>` |

---

## Custom Commands

### General

| Command | Action | Description |
|---------|--------|-------------|
| `:W` | Save | Alias for `:w` |
| `:Q` | Quit | Alias for `:q` |
| `:WQ` | Save and quit | Alias for `:wq` |
| `:Wq` | Save and quit | Alias for `:wq` |
| `:Format` | Format buffer | Format current buffer with LSP |

### Linux Kernel Development

| Command | Action | Description |
|---------|--------|-------------|
| `:KernelGenCompileCommands` | Generate compile_commands.json | For LSP support (make method) |
| `:KernelGenCompileCommandsAlt` | Generate compile_commands.json | For LSP support (script method) |

### LSP Management

| Command | Action | Description |
|---------|--------|-------------|
| `:LspInfo` | LSP info | Show attached LSP servers |
| `:LspRestart` | Restart LSP | Restart LSP servers |
| `:LspStart` | Start LSP | Start LSP servers |
| `:LspStop` | Stop LSP | Stop LSP servers |
| `:Mason` | Mason UI | Open Mason LSP installer |

### Plugin Management

| Command | Action | Description |
|---------|--------|-------------|
| `:Lazy` | Lazy UI | Open plugin manager |
| `:Lazy sync` | Sync plugins | Install/update plugins |
| `:Lazy clean` | Clean plugins | Remove unused plugins |
| `:Lazy update` | Update plugins | Update all plugins |

---

## Linux Kernel Development

When working in a Linux kernel source tree:

1. **Generate compile_commands.json** (required for LSP):
   ```vim
   :KernelGenCompileCommands
   ```

2. **Navigate kernel code**:
   - `gd` - Jump to function definition
   - `gr` - Find all uses of a function
   - `K` - Show function documentation
   - `<leader>ds` - Search symbols in current file
   - `<leader>ws` - Search symbols in entire kernel

3. **Auto-detection**:
   - Opening `.c` or `.h` files in a kernel tree shows a hint if `compile_commands.json` is missing

---

## Diff Mode

When in diff mode (`nvim -d file1 file2`):

| Key | Action | Description |
|-----|--------|-------------|
| `.` | Next diff | Jump to next change |
| `,` | Previous diff | Jump to previous change |
| `]c` | Next change | Standard vim diff next |
| `[c` | Previous change | Standard vim diff previous |
| `do` | Diff obtain | Get changes from other file |
| `dp` | Diff put | Put changes to other file |

---

## Disabled Keybindings

For safety and to avoid accidents:

| Key | Original Action | Status |
|-----|----------------|---------|
| `Q` | Ex mode | **Disabled** |
| `q:` | Command history | **Disabled** |

---

## Tips

1. **Discover keybindings**: Press `<Space>` and wait - which-key will show available commands
2. **LSP features**: Open a code file and try `gd`, `gr`, `K` to explore LSP features
3. **Fuzzy finding**: Use `<leader>f` for files, `<leader>/` to search content
4. **Buffer workflow**: Use `\]` and `\[` to navigate buffers, `\q` to close
5. **Function keys**: Quick toggles for common tasks (wrap, numbers, spell check)

---

## Auto-behaviors

Some things happen automatically:

- **Highlight on yank** - Briefly highlights text when you yank (copy) it
- **Email formatting** - `.mail`, `.patch`, `.txt` files get 72-char line width
- **Tmux reload** - `.tmux.conf` auto-reloads on save
- **Swap file handling** - Opens files in read-only if already open elsewhere
- **RST files** - Syntax highlighting disabled for reStructuredText

---

## Configuration Files

This configuration is organized into modules:

- `init.lua` - Main configuration and plugin setup
- `lua/_options.lua` - Editor options and settings
- `lua/_keymaps.lua` - Custom keybindings
- `lua/_fzf.lua` - FZF fuzzy finder keybindings
- `lua/_lsp.lua` - LSP configuration and keybindings
- `lua/_treesitter.lua` - Treesitter text objects
- `lua/_tree.lua` - NvimTree file explorer
- `lua/_cmp.lua` - Completion configuration
- `lua/_whichkey.lua` - Which-key documentation
- `lua/_kernel.lua` - Linux kernel development helpers

---

## See Also

- [Kernel LSP Setup Guide](../../docs/kernel-lsp-setup.md) - Detailed guide for Linux kernel development
- [Neovim Documentation](https://neovim.io/doc/) - Official Neovim docs
- [Which-Key](https://github.com/folke/which-key.nvim) - Interactive keybinding help
