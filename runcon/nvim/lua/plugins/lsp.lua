-- [[ LSP Configuration ]]

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Mason for LSP server installation
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Status updates for LSP
      { 'j-hui/fidget.nvim', opts = {} },

      -- Neovim Lua development
      'folke/neodev.nvim',
    },
    config = function()
      -- Helper function to find compile_commands.json in build/ directory
      local function find_compile_commands()
        local current_dir = vim.fn.expand('%:p:h')

        local root = vim.fs.root(current_dir, function(name, path)
          local build_dir = vim.fs.joinpath(path, 'build')
          local compile_commands = vim.fs.joinpath(build_dir, 'compile_commands.json')
          return vim.fn.filereadable(compile_commands) == 1
        end)

        if root then
          return vim.fs.joinpath(root, 'build')
        end

        return nil
      end

      -- LSP keymaps (attached when LSP connects)
      local on_attach = function(_, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
        end

        -- Code actions under <leader>c prefix
        map('<leader>cr', vim.lsp.buf.rename, '[C]ode [R]ename')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('<leader>cf', vim.lsp.buf.format, '[C]ode [F]ormat')

        -- Go to definitions/references
        map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
        map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('<leader>ct', vim.lsp.buf.type_definition, '[C]ode [T]ype definition')

        -- Symbols and documentation
        map('<leader>cs', vim.lsp.buf.document_symbol, '[C]ode [S]ymbols (document)')
        map('<leader>cS', vim.lsp.buf.workspace_symbol, '[C]ode [S]ymbols (workspace)')
        map('K', vim.lsp.buf.hover, 'Hover Documentation')
        map('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')

        -- Workspace folders
        map('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd folder')
        map('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove folder')
        map('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist folders')
      end

      -- Setup neodev for Neovim Lua development
      require('neodev').setup()

      -- Get capabilities from cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
      if cmp_ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      -- Server configurations
      local servers = {
        clangd = {
          cmd = function()
            local base_cmd = {
              'clangd',
              '--background-index',
              '--clang-tidy',
              '--header-insertion=iwyu',
              '--completion-style=detailed',
              '--function-arg-placeholders',
              '--fallback-style=llvm',
            }

            local compile_commands_dir = find_compile_commands()
            if compile_commands_dir then
              table.insert(base_cmd, '--compile-commands-dir=' .. compile_commands_dir)
            end

            return base_cmd
          end,
          init_options = {
            clangdFileStatus = true,
            usePlaceholders = true,
            completeUnimported = true,
            semanticHighlighting = true,
          },
        },
        gopls = {
          gopls = {
            analyses = {
              unusedparams = true,
            },
            staticcheck = true,
          },
        },
        pyright = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = 'workspace',
            },
          },
        },
        rust_analyzer = {
          ['rust-analyzer'] = {
            checkOnSave = {
              command = 'clippy',
            },
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
            },
            procMacro = {
              enable = true,
            },
            diagnostics = {
              enable = true,
              experimental = {
                enable = true,
              },
            },
          },
        },
        ts_ls = {},
        bashls = {},
        jsonls = {},
        yamlls = {},
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
      }

      -- Setup Mason
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = vim.tbl_filter(function(server)
          -- Don't auto-install rust_analyzer if already installed via rustup
          return server ~= 'rust_analyzer' or vim.fn.executable('rust-analyzer') ~= 1
        end, vim.tbl_keys(servers)),
      })

      -- Default filetypes for servers
      local default_filetypes = {
        clangd = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
        gopls = { 'go', 'gomod', 'gowork', 'gotmpl' },
        pyright = { 'python' },
        rust_analyzer = { 'rust' },
        ts_ls = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
        bashls = { 'sh', 'bash' },
        jsonls = { 'json', 'jsonc' },
        yamlls = { 'yaml' },
        lua_ls = { 'lua' },
      }

      -- Setup each LSP server
      for server_name, server_config in pairs(servers) do
        local filetypes = server_config.filetypes or default_filetypes[server_name] or {}

        vim.api.nvim_create_autocmd('FileType', {
          pattern = filetypes,
          callback = function(args)
            -- Determine cmd
            local cmd
            if server_config.cmd then
              if type(server_config.cmd) == 'function' then
                cmd = server_config.cmd()
              else
                cmd = server_config.cmd
              end
            else
              cmd = { server_name }
            end

            -- Build settings
            local settings = {}
            for key, value in pairs(server_config) do
              if key ~= 'cmd' and key ~= 'init_options' and key ~= 'filetypes' then
                settings[key] = value
              end
            end

            -- Find root directory
            local root_dir = vim.fs.root(args.buf, {
              '.git',
              'Makefile',
              'go.mod',
              'package.json',
              'Cargo.toml',
              'pyproject.toml',
            })
            if not root_dir then
              root_dir = vim.fn.getcwd()
            end

            -- Start LSP client
            vim.lsp.start({
              name = server_name,
              cmd = cmd,
              root_dir = root_dir,
              settings = settings,
              capabilities = capabilities,
              init_options = server_config.init_options,
              on_attach = on_attach,
            })
          end,
        })
      end

      -- Update which-key with LSP groups
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
