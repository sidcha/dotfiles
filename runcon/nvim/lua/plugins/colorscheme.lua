-- [[ Colorscheme ]]

return {
  {
    'shaunsingh/seoul256.nvim',
    priority = 1000, -- Load before other plugins
    config = function()
      vim.g.seoul256_disable_background = true
      require('seoul256')
    end,
  },
}
