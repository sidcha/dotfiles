-- [[ UI Plugins ]]

return {
  -- Status line
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = false,
        theme = 'seoul256',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  -- Which-key for keybinding hints
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {},
    config = function()
      local wk = require('which-key')

      -- Register key groups and descriptions
      wk.add({
        -- Diagnostic navigation
        { '[d', desc = 'Previous diagnostic' },
        { ']d', desc = 'Next diagnostic' },
        { '<leader>e', desc = 'Show diagnostic error' },
        { '<leader>q', desc = 'Diagnostics quickfix list' },

        -- Git hunk navigation
        { '[c', desc = 'Previous git change' },
        { ']c', desc = 'Next git change' },
        { '<leader>hp', desc = 'Preview git hunk' },

        -- Function navigation (treesitter)
        { '[m', desc = 'Previous function start' },
        { ']m', desc = 'Next function start' },
        { '[M', desc = 'Previous function end' },
        { ']M', desc = 'Next function end' },
        { '[[', desc = 'Previous class start' },
        { ']]', desc = 'Next class start' },
        { '[]', desc = 'Previous class end' },
        { '][', desc = 'Next class end' },

        -- Buffer management
        { '<Bslash>[', desc = 'Previous buffer' },
        { '<Bslash>]', desc = 'Next buffer' },
        { '<Bslash>q', desc = 'Close buffer' },
        { '<Bslash>o', desc = 'Close other buffers' },
        { '<Bslash>t', desc = 'Toggle file tree' },

        -- Function keys
        { '<F2>', desc = 'Trim whitespace' },
        { '<F3>', desc = 'Toggle line numbers' },
        { '<F4>', desc = 'Toggle wrap' },
        { '<F5>', desc = 'Toggle spell check' },
        { '<F6>', desc = 'Git blame' },

        -- Movement
        { 'gm', desc = 'Go to middle of line' },
        { 's', desc = 'Leap forward' },
        { 'S', desc = 'Leap backward' },
        { 'gs', desc = 'Leap from windows' },

        -- Treesitter parameter swapping
        { '<leader>a', desc = 'Swap next parameter' },
        { '<leader>A', desc = 'Swap previous parameter' },
      })
    end,
  },

  -- File tree
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    cmd = 'NvimTreeToggle',
    keys = {
      { '<Bslash>t', ':NvimTreeToggle<CR>', desc = 'Toggle file tree' },
    },
    opts = {},
  },
}
