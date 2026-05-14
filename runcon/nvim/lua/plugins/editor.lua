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

  -- EditorConfig: provided by Neovim 0.9+ runtime, no plugin needed.

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

  -- Comment plugin. Lazy-load on the default mappings so its 5 submodules
  -- don't eat ~500ms of startup.
  {
    'numToStr/Comment.nvim',
    keys = {
      { 'gc', mode = { 'n', 'x' }, desc = 'Comment toggle linewise' },
      { 'gb', mode = { 'n', 'x' }, desc = 'Comment toggle blockwise' },
      { 'gcc', mode = 'n', desc = 'Comment toggle current line' },
      { 'gbc', mode = 'n', desc = 'Comment toggle current block' },
    },
    opts = {},
  },
}
