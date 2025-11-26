-- [[ Editor Enhancement Plugins ]]

return {
  -- Set some sensible defaults
  { 'tpope/vim-sensible' },

  -- Detect tabstop and shiftwidth automatically
  { 'tpope/vim-sleuth' },

  -- Open files with file_name:N
  { 'wsdjeg/vim-fetch' },

  -- Open files at last edit position
  { 'farmergreg/vim-lastplace' },

  -- EditorConfig support
  { 'editorconfig/editorconfig-vim' },

  -- Make f key smarter
  { 'rhysd/clever-f.vim' },

  -- Faster sneak-like movement
  {
    'ggandor/leap.nvim',
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, desc = 'Leap forward to' },
      { 'S', mode = { 'n', 'x', 'o' }, desc = 'Leap backward to' },
      { 'gs', mode = { 'n', 'x', 'o' }, desc = 'Leap from windows' },
    },
    config = function()
      local leap = require('leap')
      leap.add_default_mappings(true)
      vim.keymap.del({ 'x', 'o' }, 'x')
      vim.keymap.del({ 'x', 'o' }, 'X')
    end,
  },

  -- Comment plugin
  {
    'numToStr/Comment.nvim',
    opts = {},
  },
}
