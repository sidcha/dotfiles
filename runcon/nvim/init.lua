-- ============================================================================
-- Neovim Configuration
-- ============================================================================

-- Set leader keys before lazy.nvim loads
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Bootstrap lazy.nvim plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load core configuration
require('config.options')
require('config.keymaps')
require('config.autocmds')

-- Setup plugins (lazy.nvim auto-loads from lua/plugins/)
require('lazy').setup('plugins', {
  -- Lazy.nvim configuration
  defaults = {
    lazy = false, -- Plugins are not lazy-loaded by default
    version = false, -- Don't use version pinning by default
  },
  install = {
    colorscheme = { 'seoul256' },
  },
  checker = {
    enabled = false, -- Don't automatically check for updates
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})
