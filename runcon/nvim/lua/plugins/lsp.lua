-- [[ LSP — Neovim 0.11+ vim.lsp.config / vim.lsp.enable ]]
--
-- Per-server configs live in `lsp/<name>.lua` at the runtimepath root
-- (auto-discovered by Neovim 0.11). This file wires up the glue:
-- shared capabilities, LspAttach keymaps, server installation via Mason,
-- and the single vim.lsp.enable call that activates them all.

return {
  -- Install/manage external LSP server binaries.
  {
    'mason-org/mason.nvim',
    lazy = false,
    config = function()
      require('mason').setup()

      local ensure_installed = {
        'gopls',
        'pyright',
        'typescript-language-server',
        'bash-language-server',
        'json-lsp',
        'yaml-language-server',
        'lua-language-server',
      }
      -- Mason has no aarch64-linux build for clangd; only add it on
      -- platforms where Mason can actually install a prebuilt, and only
      -- if it isn't already on $PATH (system-installed via apt etc.).
      local sysname = (vim.uv or vim.loop).os_uname()
      local mason_has_clangd =
        sysname.sysname == 'Darwin'
        or (sysname.sysname == 'Linux' and sysname.machine == 'x86_64')
        or sysname.sysname:match('Windows')
      if mason_has_clangd and vim.fn.executable('clangd') ~= 1 then
        table.insert(ensure_installed, 'clangd')
      end
      if vim.fn.executable('rust-analyzer') ~= 1 then
        table.insert(ensure_installed, 'rust-analyzer')
      end

      local mr = require('mason-registry')
      local function install(pkg)
        if mr.has_package(pkg) and not mr.is_installed(pkg) then
          mr.get_package(pkg):install()
        end
      end
      if mr.refresh then
        mr.refresh(function()
          for _, p in ipairs(ensure_installed) do install(p) end
        end)
      else
        for _, p in ipairs(ensure_installed) do install(p) end
      end
    end,
  },

  -- LSP progress UI. Loads on LspAttach so it doesn't add ~200ms to startup
  -- when no LSP is active yet.
  { 'j-hui/fidget.nvim', event = 'LspAttach', opts = {} },

  -- Replaces neodev.nvim: auto-configures lua_ls for nvim Lua dev (loads
  -- the runtime types only when editing nvim plugin/config files).
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },

  -- Glue: capabilities, keymaps, server enable.
  {
    'hrsh7th/cmp-nvim-lsp',
    lazy = false,
    dependencies = { 'mason-org/mason.nvim', 'folke/lazydev.nvim' },
    config = function()
      -- 1) Shared capabilities — applied to every server via the '*' config.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
      if ok then
        capabilities = vim.tbl_deep_extend('force', capabilities, cmp_lsp.default_capabilities())
      end
      vim.lsp.config('*', {
        capabilities = capabilities,
        root_markers = { '.git' },
      })

      -- 2) Buffer-local keymaps when any LSP attaches.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
        callback = function(args)
          local bufnr = args.buf
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
          end

          map('<leader>cr', vim.lsp.buf.rename,                                '[C]ode [R]ename')
          map('<leader>ca', vim.lsp.buf.code_action,                           '[C]ode [A]ction')
          map('<leader>cf', function() vim.lsp.buf.format({ async = true }) end, '[C]ode [F]ormat')

          map('gd',         vim.lsp.buf.definition,                            '[G]oto [D]efinition')
          map('gr',         vim.lsp.buf.references,                            '[G]oto [R]eferences')
          map('gI',         vim.lsp.buf.implementation,                        '[G]oto [I]mplementation')
          map('gD',         vim.lsp.buf.declaration,                           '[G]oto [D]eclaration')
          map('<leader>ct', vim.lsp.buf.type_definition,                       '[C]ode [T]ype definition')

          map('<leader>cs', vim.lsp.buf.document_symbol,                       '[C]ode [S]ymbols (document)')
          map('<leader>cS', vim.lsp.buf.workspace_symbol,                      '[C]ode [S]ymbols (workspace)')
          map('K',          vim.lsp.buf.hover,                                 'Hover Documentation')
          map('<C-k>',      vim.lsp.buf.signature_help,                        'Signature Help')

          map('<leader>wa', vim.lsp.buf.add_workspace_folder,                  '[W]orkspace [A]dd folder')
          map('<leader>wr', vim.lsp.buf.remove_workspace_folder,               '[W]orkspace [R]emove folder')
          map('<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, '[W]orkspace [L]ist folders')
        end,
      })

      -- 3) Enable servers (names match files under lsp/<name>.lua).
      vim.lsp.enable({
        'clangd',
        'gopls',
        'pyright',
        'rust_analyzer',
        'ts_ls',
        'bashls',
        'jsonls',
        'yamlls',
        'lua_ls',
      })

      -- 4) which-key group labels (no-op if which-key isn't loaded).
      local wk_ok, wk = pcall(require, 'which-key')
      if wk_ok then
        wk.add({
          { '<leader>c', group = '[C]ode' },
          { '<leader>w', group = '[W]orkspace' },
          { 'gd', desc = 'LSP: Goto definition' },
          { 'gr', desc = 'LSP: Goto references' },
          { 'gI', desc = 'LSP: Goto implementation' },
          { 'gD', desc = 'LSP: Goto declaration' },
          { 'K', desc = 'LSP: Hover documentation' },
        })
      end
    end,
  },
}
