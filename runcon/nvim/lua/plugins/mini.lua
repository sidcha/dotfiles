-- [[ Mini.nvim - Minimal Plugin Modules ]]

return {
  -- Icon support (replaces nvim-web-devicons)
  {
    'nvim-mini/mini.icons',
    lazy = false,
    priority = 100,
    opts = {},
    init = function()
      -- Make mini.icons work with other plugins expecting nvim-web-devicons
      package.preload['nvim-web-devicons'] = function()
        require('mini.icons').mock_nvim_web_devicons()
        return package.loaded['nvim-web-devicons']
      end
    end,
  },

  -- Surround text objects (better than vim-surround)
  {
    'nvim-mini/mini.surround',
    event = 'VeryLazy',
    opts = {
      mappings = {
        add = 'sa', -- Add surrounding in Normal and Visual modes
        delete = 'sd', -- Delete surrounding
        find = 'sf', -- Find surrounding (to the right)
        find_left = 'sF', -- Find surrounding (to the left)
        highlight = 'sh', -- Highlight surrounding
        replace = 'sr', -- Replace surrounding
        update_n_lines = 'sn', -- Update `n_lines`
      },
    },
  },
}
