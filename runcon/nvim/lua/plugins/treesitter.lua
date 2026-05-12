-- [[ Treesitter - Syntax Highlighting ]]

return {
  {
    'nvim-treesitter/nvim-treesitter',
    -- nvim-treesitter switched the default branch from 'master' to 'main' in
    -- late 2024. The 'main' rewrite removed configs.setup(), highlight,
    -- incremental_selection, and bundled textobjects — none of which can be
    -- recreated from the new API alone. Stay on 'master' until we migrate.
    branch = 'master',
    build = ':TSUpdate',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'master' },
    },
    config = function()
      -- Skip ensure_installed if no C compiler is available — otherwise
      -- nvim-treesitter prints "No C compiler found!" once per parser at
      -- startup. Users on minimal boxes can :TSInstall manually later.
      local has_cc = false
      for _, c in ipairs({ 'cc', 'gcc', 'clang', 'cl', 'zig' }) do
        if vim.fn.executable(c) == 1 then has_cc = true; break end
      end
      local parsers = has_cc and {
        'c', 'cpp', 'go', 'lua', 'python', 'rust',
        'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash',
      } or {}

      -- Defer setup to improve startup time
      vim.defer_fn(function()
        require('nvim-treesitter.configs').setup({
          ensure_installed = parsers,
          auto_install = false,
          highlight = { enable = true },
          indent = { enable = true },
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = '<c-space>',
              node_incremental = '<c-space>',
              scope_incremental = '<c-s>',
              node_decremental = '<M-space>',
            },
          },
          textobjects = {
            select = {
              enable = true,
              lookahead = true,
              keymaps = {
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
              },
            },
            move = {
              enable = true,
              set_jumps = true,
              goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
              },
              goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
              },
              goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
              },
              goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
              },
            },
            swap = {
              enable = true,
              swap_next = {
                ['<leader>a'] = '@parameter.inner',
              },
              swap_previous = {
                ['<leader>A'] = '@parameter.inner',
              },
            },
          },
        })
      end, 0)
    end,
  },
}
