# Neovim Configuration

Modern Neovim configuration with LSP, Telescope, and quality-of-life enhancements.

**Leader Key**: `<Space>`

**Tip**: Press `<Space>` in normal mode to see a which-key popup with all available keybindings!

---

## Table of Contents

- [Installed Plugins](#installed-plugins)
- [Keybindings](#keybindings)
  - [Leader Key Bindings](#leader-key-bindings)
  - [LSP Keybindings](#lsp-keybindings)
  - [Backslash Bindings](#backslash-bindings)
  - [Function Keys](#function-keys)
  - [Navigation](#navigation)
  - [Editing](#editing)
- [Custom Commands](#custom-commands)
- [Configuration Structure](#configuration-structure)
- [Tips & Tricks](#tips--tricks)

---

## Installed Plugins

### Core Plugins

| Plugin | Purpose | Triggered By |
|--------|---------|--------------|
| **lazy.nvim** | Plugin manager | Automatic |
| **seoul256.nvim** | Colorscheme | Automatic |
| **nvim-lspconfig** | LSP client configuration | Opening code files |
| **mason.nvim** | LSP server installer | `:Mason` |
| **mason-lspconfig.nvim** | Bridge mason ↔ lspconfig | Automatic |

### Editor Enhancement

| Plugin | Purpose | Triggered By |
|--------|---------|--------------|
| **vim-sensible** | Sensible defaults | Automatic |
| **vim-sleuth** | Auto-detect indent | Automatic |
| **vim-fetch** | Open files with `:line` | `nvim file.txt:42` |
| **vim-lastplace** | Remember last position | Opening files |
| **editorconfig-vim** | EditorConfig support | `.editorconfig` files |
| **clever-f.vim** | Smarter `f`/`F` movement | `f`, `F`, `t`, `T` |
| **leap.nvim** | Fast motion | `s`, `S`, `gs` |
| **Comment.nvim** | Toggle comments | `gcc`, `gc` |

### Git Integration

| Plugin | Purpose | Triggered By |
|--------|---------|--------------|
| **vim-fugitive** | Git commands | `:Git`, `<F6>` |
| **vim-rhubarb** | GitHub integration | `:GBrowse` |
| **gitsigns.nvim** | Git diff signs | Git repositories |

### UI & Navigation

| Plugin | Purpose | Triggered By |
|--------|---------|--------------|
| **telescope.nvim** | Fuzzy finder | `<leader>f`, `<leader>g`, etc. |
| **telescope-fzf-native** | Fast sorting | Telescope |
| **lualine.nvim** | Statusline | Automatic |
| **which-key.nvim** | Keybinding hints | `<Space>` (after delay) |
| **nvim-tree.lua** | File explorer | `<Bslash>t` |

### Code Intelligence

| Plugin | Purpose | Triggered By |
|--------|---------|--------------|
| **nvim-treesitter** | Syntax highlighting | Opening code files |
| **nvim-treesitter-textobjects** | Smart text objects | `af`, `if`, `aa`, `ia`, etc. |
| **nvim-cmp** | Completion engine | Insert mode |
| **LuaSnip** | Snippet engine | Insert mode |
| **cmp-nvim-lsp** | LSP completions | Insert mode with LSP |
| **friendly-snippets** | Snippet collection | Insert mode |
| **neodev.nvim** | Lua/Neovim dev | Lua files |
| **fidget.nvim** | LSP progress | LSP operations |

### Quality of Life (snacks.nvim)

| Plugin | Purpose | Triggered By |
|--------|---------|--------------|
| **snacks.bigfile** | Optimize large files | Files >1.5MB |
| **snacks.notifier** | Beautiful notifications | `vim.notify()` |
| **snacks.quickfile** | Fast file rendering | Opening files |
| **snacks.gitbrowse** | Open files in browser | `<leader>gb`, `<leader>gB` |

### Mini.nvim Modules

| Plugin | Purpose | Triggered By |
|--------|---------|--------------|
| **mini.icons** | Icon support | Automatic (replaces nvim-web-devicons) |
| **mini.surround** | Surround text | `sa`, `sd`, `sr` |

### Specialized

| Plugin | Purpose | Triggered By |
|--------|---------|--------------|
| **kernel-dev-tools** | Linux kernel dev | Opening `.c`/`.h` in kernel tree |

---

## Keybindings

### Leader Key Bindings

#### Telescope (Fuzzy Finder)

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>f` | `:Telescope find_files` | Find files |
| `<leader>g` | `:Telescope git_files` | Find git files |
| `<leader>/` | `:Telescope live_grep` | Search in files (ripgrep) |
| `<leader>h` | `:Telescope oldfiles` | Recent files |
| `<leader>b` | `:Telescope buffers` | Open buffers |
| `<leader>t` | `:Telescope current_buffer_tags` | Tags in buffer |
| `<leader>T` | `:Telescope tags` | Tags in project |
| `<leader>c` | `:Telescope git_bcommits` | Buffer commits |
| `<leader>C` | `:Telescope git_commits` | All commits |
| `<leader>?` | `:Telescope help_tags` | Help tags |
| `<leader><space>` | `:Telescope resume` | Resume last picker |

**In Telescope:**
- `<C-j>/<C-k>` - Navigate results
- `<CR>` - Open file
- `<C-x>` - Open in split
- `<C-v>` - Open in vsplit
- `<C-t>` - Open in tab
- `<Esc>` - Close

#### Git

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>hp` | Preview hunk | Preview git hunk changes |
| `<leader>gb` | Git browse | Open file in browser (GitHub/GitLab) |
| `<leader>gB` | Git browse (copy) | Copy URL to clipboard |
| `[c` | Previous change | Jump to previous git hunk |
| `]c` | Next change | Jump to next git hunk |

#### Diagnostics

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>e` | Open diagnostic float | Show error in floating window |
| `<leader>q` | Diagnostic quickfix | Open diagnostics in quickfix list |
| `[d` | Previous diagnostic | Jump to previous error/warning |
| `]d` | Next diagnostic | Jump to next error/warning |

#### Treesitter (Code Actions)

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>a` | Swap next parameter | Swap with next function parameter |
| `<leader>A` | Swap previous parameter | Swap with previous function parameter |

---

### LSP Keybindings

**Available when an LSP server is attached to the buffer.**

#### Code Actions (under `<leader>c`)

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>cr` | Rename | Rename symbol under cursor |
| `<leader>ca` | Code action | Show available code actions |
| `<leader>cf` | Format | Format current buffer |
| `<leader>ct` | Type definition | Show type definition |
| `<leader>cs` | Document symbols | List symbols in current file |
| `<leader>cS` | Workspace symbols | List symbols in workspace |

#### Navigation

| Key | Command | Description |
|-----|---------|-------------|
| `gd` | Go to definition | Jump to definition |
| `gD` | Go to declaration | Jump to declaration |
| `gr` | Find references | List all references |
| `gI` | Go to implementation | Jump to implementation |
| `K` | Hover documentation | Show documentation |
| `<C-k>` | Signature help | Show function signature |

#### Workspace Management

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>wa` | Add workspace folder | Add folder to workspace |
| `<leader>wr` | Remove workspace folder | Remove folder from workspace |
| `<leader>wl` | List workspace folders | Show workspace folders |

---

### Backslash Bindings

Buffer and file tree management:

| Key | Command | Description |
|-----|---------|-------------|
| `<Bslash>[` | Previous buffer | Switch to previous buffer |
| `<Bslash>]` | Next buffer | Switch to next buffer |
| `<Bslash>q` | Close buffer | Close current buffer, go to previous |
| `<Bslash>o` | Close other buffers | Close all buffers except current |
| `<Bslash>t` | Toggle file tree | Open/close NvimTree file explorer |

---

### Function Keys

| Key | Command | Description |
|-----|---------|-------------|
| `<F2>` | Trim whitespace | Remove trailing whitespace from file |
| `<F3>` | Toggle line numbers | Toggle line numbers and relative numbers |
| `<F4>` | Toggle wrap | Toggle line wrapping |
| `<F5>` | Toggle spell check | Toggle spell checking |
| `<F6>` | Git blame | Show git blame |

---

### Navigation

#### Basic Movement

| Key | Command | Description |
|-----|---------|-------------|
| `j` / `k` | Move down/up | Respects word wrap (gj/gk) |
| `gm` | Go to middle | Jump to middle of current line |
| `<PageUp>` | Half page up | Same as `<C-u>` |
| `<PageDown>` | Half page down | Same as `<C-d>` |
| `<S-Up>` | Up | Remap shift+up to normal up |
| `<S-Down>` | Down | Remap shift+down to normal down |

#### Leap Motion (Fast Movement)

| Key | Command | Description |
|-----|---------|-------------|
| `s{char}{char}` | Leap forward | Jump to {char}{char} forward |
| `S{char}{char}` | Leap backward | Jump to {char}{char} backward |
| `gs{char}{char}` | Leap from windows | Jump across windows |

#### Function/Class Navigation (Treesitter)

| Key | Command | Description |
|-----|---------|-------------|
| `]m` | Next function start | Jump to next function |
| `[m` | Previous function start | Jump to previous function |
| `]M` | Next function end | Jump to end of next function |
| `[M` | Previous function end | Jump to end of previous function |
| `]]` | Next class start | Jump to next class |
| `[[` | Previous class start | Jump to previous class |
| `][` | Next class end | Jump to end of next class |
| `[]` | Previous class end | Jump to end of previous class |

---

### Editing

#### Mini.surround

| Key | Command | Description |
|-----|---------|-------------|
| `sa{motion}{char}` | Add surround | Add {char} around {motion} |
| `sd{char}` | Delete surround | Delete surrounding {char} |
| `sr{old}{new}` | Replace surround | Replace {old} with {new} |
| `sf{char}` | Find surround (right) | Find next {char} |
| `sF{char}` | Find surround (left) | Find previous {char} |
| `sh{char}` | Highlight surround | Highlight surrounding {char} |

**Examples:**
- `saiw"` - Surround word with quotes
- `sd"` - Delete surrounding quotes
- `sr"'` - Replace double quotes with single quotes

#### Comments

| Key | Command | Description |
|-----|---------|-------------|
| `gcc` | Comment line | Comment/uncomment current line |
| `gc{motion}` | Comment motion | Comment/uncomment motion |
| `gc` (visual) | Comment selection | Comment/uncomment visual selection |

#### Other

| Key | Command | Description |
|-----|---------|-------------|
| `<F2>` | Trim whitespace | Remove trailing whitespace |
| `<C-q>` | Visual block mode | Start visual block selection |

#### Treesitter Text Objects

| Key | Command | Description |
|-----|---------|-------------|
| `af` / `if` | Function outer/inner | Select function |
| `ac` / `ic` | Class outer/inner | Select class |
| `aa` / `ia` | Parameter outer/inner | Select parameter |

#### Incremental Selection

| Key | Command | Description |
|-----|---------|-------------|
| `<C-Space>` | Increment selection | Expand selection to next syntax node |
| `<C-s>` | Scope increment | Expand to scope |
| `<M-Space>` | Decrement selection | Shrink selection |

---

## Custom Commands

### General

| Command | Description |
|---------|-------------|
| `:W` | Alias for `:w` |
| `:Q` | Alias for `:q` |
| `:WQ` / `:Wq` | Alias for `:wq` |

### LSP Management

| Command | Description |
|---------|-------------|
| `:LspInfo` | Show attached LSP servers |
| `:LspRestart` | Restart LSP servers |
| `:LspStart` | Start LSP servers |
| `:LspStop` | Stop LSP servers |
| `:Mason` | Open Mason LSP installer |

### Plugin Management

| Command | Description |
|---------|-------------|
| `:Lazy` | Open plugin manager |
| `:Lazy sync` | Install/update plugins |
| `:Lazy clean` | Remove unused plugins |
| `:Lazy update` | Update all plugins |

### Linux Kernel Development

| Command | Description |
|---------|-------------|
| `:KernelGenCompileCommands` | Generate compile_commands.json (make method) |
| `:KernelGenCompileCommandsAlt` | Generate compile_commands.json (script method) |

---

## Configuration Structure

```
~/.config/nvim/
├── init.lua                    # Entry point - loads everything
├── lua/
│   ├── config/                 # Core configuration
│   │   ├── options.lua         # Vim options
│   │   ├── keymaps.lua         # Core keymaps
│   │   └── autocmds.lua        # Autocommands
│   └── plugins/                # Plugin specifications (auto-loaded)
│       ├── colorscheme.lua     # Seoul256 colorscheme
│       ├── completion.lua      # nvim-cmp + LuaSnip
│       ├── editor.lua          # Editor plugins (leap, clever-f, etc.)
│       ├── git.lua             # Git plugins (fugitive, gitsigns)
│       ├── kernel.lua          # Linux kernel development
│       ├── lsp.lua             # LSP configuration
│       ├── mini.lua            # mini.nvim modules
│       ├── snacks.lua          # snacks.nvim QoL plugins
│       ├── telescope.lua       # Telescope fuzzy finder
│       ├── treesitter.lua      # Treesitter configuration
│       └── ui.lua              # UI plugins (lualine, which-key, nvim-tree)
└── .backup/                    # Old configuration files (safe to delete)
```

---

## Tips & Tricks

### General Workflow

1. **Discover keybindings**: Press `<Space>` and wait - which-key will show available commands
2. **Find files**: `<leader>f` for all files, `<leader>g` for git files
3. **Search content**: `<leader>/` to search text across files
4. **Buffer workflow**: `<Bslash>]` and `<Bslash>[` to navigate, `<Bslash>q` to close
5. **Quick toggles**: Use function keys for common tasks

### LSP Features

1. **Navigate code**: `gd` to jump to definition, `gr` to find references
2. **Documentation**: `K` to show docs, `<C-k>` for signature help
3. **Refactor**: `<leader>cr` to rename, `<leader>ca` for code actions
4. **Symbols**: `<leader>cs` for file symbols, `<leader>cS` for workspace

### Git Integration

1. **Browse on GitHub**: `<leader>gb` opens current file/line in browser
2. **Copy GitHub URL**: `<leader>gB` copies URL to clipboard
3. **Review changes**: `<leader>hp` to preview hunks, `[c`/`]c` to navigate
4. **Git blame**: `<F6>` to see git blame

### Telescope Tips

1. **Resume last search**: `<leader><space>`
2. **In picker**: Use `<C-j>`/`<C-k>` to navigate
3. **Preview toggle**: `<C-/>` toggles preview
4. **Multi-select**: `<Tab>` to select, `<S-Tab>` to deselect

### Editing Enhancements

1. **Surround**: `saiw"` to surround word with quotes
2. **Fast motion**: `s{char}{char}` to jump anywhere
3. **Smart f**: `f` and `;` to repeat in same direction
4. **Text objects**: `daf` to delete function, `cic` to change class

---

## Auto-behaviors

Some things happen automatically:

- **Highlight on yank** - Briefly highlights text when you yank (copy) it
- **Email formatting** - `.mail`, `.patch`, `.txt` files get 72-char line width
- **Tmux reload** - `.tmux.conf` auto-reloads on save
- **Swap file handling** - Opens files in read-only if already open elsewhere
- **RST files** - Syntax highlighting disabled for reStructuredText
- **Large files** - Files >1.5MB get optimized (disabled plugins, syntax)
- **Kernel detection** - Shows hint when opening C files in kernel tree

---

## LSP Servers

Configured LSP servers (auto-installed via Mason):

| Language | Server | Features |
|----------|--------|----------|
| **C/C++** | clangd | Auto-finds `build/compile_commands.json` |
| **Go** | gopls | Full Go support |
| **Python** | pyright | Type checking, completions |
| **Rust** | rust_analyzer | Uses system install if available |
| **JavaScript/TypeScript** | ts_ls | Full TS/JS support |
| **Bash** | bashls | Shell script support |
| **JSON** | jsonls | JSON validation |
| **YAML** | yamlls | YAML validation |
| **Lua** | lua_ls | Neovim API support |

---

## Linux Kernel Development

When working in a Linux kernel source tree:

1. **First time setup**:
   ```vim
   :KernelGenCompileCommands
   ```

2. **Workflow**:
   - Navigate with `gd`, `gr`, `gI`
   - Search symbols with `<leader>cs`, `<leader>cS`
   - Clangd automatically finds `build/compile_commands.json`

3. **Auto-detection**:
   - Opening `.c`/`.h` files shows hint if `compile_commands.json` missing

---

## Diff Mode

When in diff mode (`nvim -d file1 file2`):

| Key | Description |
|-----|-------------|
| `.` | Next diff |
| `,` | Previous diff |
| `]c` | Next change (standard) |
| `[c` | Previous change (standard) |
| `do` | Diff obtain |
| `dp` | Diff put |

---

## Disabled Keybindings

For safety and to avoid accidents:

| Key | Original Action | Status |
|-----|----------------|---------|
| `Q` | Ex mode | **Disabled** |
| `q:` | Command history | **Disabled** |

---

## See Also

- [Neovim Documentation](https://neovim.io/doc/)
- [Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [LSP Configuration](https://github.com/neovim/nvim-lspconfig)
- [Lazy.nvim](https://github.com/folke/lazy.nvim)
- [Snacks.nvim](https://github.com/folke/snacks.nvim)
- [Mini.nvim](https://github.com/nvim-mini/mini.nvim)
