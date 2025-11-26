-- [[ Snacks.nvim - Quality of Life Plugins ]]

return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      -- Large file optimization
      bigfile = {
        enabled = true,
        size = 1.5 * 1024 * 1024, -- 1.5MB
        setup = function(ctx)
          vim.cmd([[NoMatchParen]])
          vim.opt_local.foldmethod = 'manual'
          vim.opt_local.spell = false
          vim.schedule(function()
            vim.bo[ctx.buf].syntax = ctx.ft
          end)
        end,
      },

      -- Beautiful notifications
      notifier = {
        enabled = true,
        timeout = 3000,
      },

      -- Fast file rendering
      quickfile = {
        enabled = true,
      },

      -- Git browse integration
      gitbrowse = {
        enabled = true,
      },
    },
    keys = {
      {
        '<leader>gb',
        function()
          require('snacks').gitbrowse()
        end,
        desc = 'Git browse',
      },
      {
        '<leader>gB',
        function()
          require('snacks').gitbrowse({
            open = function(url)
              vim.fn.setreg('+', url)
              vim.notify('URL copied to clipboard: ' .. url)
            end,
          })
        end,
        desc = 'Git browse (copy URL)',
      },
    },
    init = function()
      -- Use snacks for vim.notify
      vim.notify = function(msg, level, opts)
        return require('snacks').notifier.notify(msg, level, opts)
      end
    end,
  },
}
