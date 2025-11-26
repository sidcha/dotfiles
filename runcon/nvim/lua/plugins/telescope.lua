-- [[ Telescope - Fuzzy Finder ]]

return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
    },
    keys = {
      -- File pickers
      { '<leader>f', '<cmd>Telescope find_files<cr>', desc = 'Find files' },
      { '<leader>g', '<cmd>Telescope git_files<cr>', desc = 'Git files' },
      { '<leader>/', '<cmd>Telescope live_grep<cr>', desc = 'Search in files' },
      { '<leader>h', '<cmd>Telescope oldfiles<cr>', desc = 'Recent files' },

      -- Buffer/Tag pickers
      { '<leader>b', '<cmd>Telescope buffers<cr>', desc = 'Buffers' },
      { '<leader>t', '<cmd>Telescope current_buffer_tags<cr>', desc = 'Tags in buffer' },
      { '<leader>T', '<cmd>Telescope tags<cr>', desc = 'Tags in project' },

      -- Git pickers
      { '<leader>C', '<cmd>Telescope git_commits<cr>', desc = 'Git commits' },
      { '<leader>c', '<cmd>Telescope git_bcommits<cr>', desc = 'Buffer commits' },

      -- Other pickers
      { '<leader>?', '<cmd>Telescope help_tags<cr>', desc = 'Help tags' },
      { '<leader><space>', '<cmd>Telescope resume<cr>', desc = 'Resume last picker' },
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
            },
          },
          layout_config = {
            horizontal = {
              preview_width = 0.5,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = false,
          },
        },
      })

      -- Load fzf extension if available
      pcall(telescope.load_extension, 'fzf')
    end,
  },
}
