-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    -- LSP navigation using built-in vim.lsp functions
    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', vim.lsp.buf.document_symbol, '[D]ocument [S]ymbols')
    nmap('<leader>ws', vim.lsp.buf.workspace_symbol, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
end

-- document existing key chains
local wk_ok, wk = pcall(require, 'which-key')
if wk_ok then
    wk.add({
        { "<leader>c", group = "[C]ode" },
        { "<leader>d", group = "[D]ocument" },
        { "<leader>r", group = "[R]ename" },
        { "<leader>w", group = "[W]orkspace" },
    })
end

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
local mason_ok, mason = pcall(require, 'mason')
if not mason_ok then
    vim.notify('Mason not installed. LSP features will not be available.', vim.log.levels.WARN)
    return
end

local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not mason_lspconfig_ok then
    vim.notify('Mason-lspconfig not installed. LSP features will not be available.', vim.log.levels.WARN)
    return
end

local lspconfig_ok, _ = pcall(require, 'lspconfig')
if not lspconfig_ok then
    vim.notify('Lspconfig not installed. LSP features will not be available.', vim.log.levels.WARN)
    return
end

mason.setup()
mason_lspconfig.setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
-- Helper function to find compile_commands.json in build/ directory
local function find_compile_commands()
    -- Search upward from current buffer's directory
    local current_dir = vim.fn.expand('%:p:h')

    -- Use vim.fs.root to find a directory containing build/compile_commands.json
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

local servers = {
    -- C/C++
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

            -- Try to find compile_commands.json in build/ directory
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

    -- Go
    gopls = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
        },
    },

    -- Python
    pyright = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
            },
        },
    },

    -- Rust
    rust_analyzer = {
        ['rust-analyzer'] = {
            checkOnSave = {
                command = "clippy",
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

    -- JavaScript/TypeScript
    ts_ls = {},

    -- Bash
    bashls = {},

    -- JSON
    jsonls = {},

    -- YAML
    yamlls = {},

    -- Lua
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

-- Setup neovim lua configuration
local neodev_ok, neodev = pcall(require, 'neodev')
if neodev_ok then
    neodev.setup()
end

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_nvim_lsp_ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- Ensure the servers above are installed
-- Note: rust_analyzer should be excluded if you have it installed via rustup
local ensure_installed = vim.tbl_keys(servers)
-- Remove rust_analyzer from auto-install if rustup version exists
if vim.fn.executable('rust-analyzer') == 1 then
    ensure_installed = vim.tbl_filter(function(server)
        return server ~= 'rust_analyzer'
    end, ensure_installed)
end

mason_lspconfig.setup {
    ensure_installed = ensure_installed,
}

-- Map of server names to common filetypes (for servers without explicit filetypes)
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

-- Setup each server with autocmds
for server_name, server_config in pairs(servers) do
    local filetypes = server_config.filetypes or default_filetypes[server_name] or {}

    vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function(args)
            -- Determine cmd (handle function or table)
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

            -- Build settings (everything except cmd, init_options, filetypes)
            local settings = {}
            for key, value in pairs(server_config) do
                if key ~= 'cmd' and key ~= 'init_options' and key ~= 'filetypes' then
                    settings[key] = value
                end
            end

            -- Find root directory
            local root_dir = vim.fs.root(args.buf, {'.git', 'Makefile', 'go.mod', 'package.json', 'Cargo.toml', 'pyproject.toml'})
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
