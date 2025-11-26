-- [[ Linux Kernel C Development Support ]]
-- This module provides helpers for C development in the Linux kernel

local M = {}

-- Check if we're in a Linux kernel source tree
M.is_kernel_tree = function()
    local kernel_markers = {
        'MAINTAINERS',
        'COPYING',
        'Kbuild',
        'Makefile',
    }

    -- Check if we have kernel-specific markers
    local has_maintainers = vim.fn.filereadable('MAINTAINERS') == 1
    local has_kbuild = vim.fn.filereadable('Kbuild') == 1

    -- Also check if Makefile contains "This is a kernel Makefile"
    if vim.fn.filereadable('Makefile') == 1 then
        local makefile = vim.fn.readfile('Makefile', '', 10)
        for _, line in ipairs(makefile) do
            if line:match('SPDX%-License%-Identifier') and line:match('GPL') then
                return has_maintainers and has_kbuild
            end
        end
    end

    return false
end

-- Generate compile_commands.json for the kernel
M.generate_compile_commands = function()
    if not M.is_kernel_tree() then
        vim.notify('Not in a Linux kernel source tree', vim.log.levels.ERROR)
        return
    end

    vim.notify('Generating compile_commands.json for kernel...', vim.log.levels.INFO)
    vim.notify('This may take a few minutes...', vim.log.levels.INFO)

    -- The kernel provides scripts to generate this
    -- Try the newer method first (kernel 5.15+)
    local cmd = 'make compile_commands.json'

    -- Run in background and notify when done
    vim.fn.jobstart(cmd, {
        on_exit = function(_, exit_code, _)
            if exit_code == 0 then
                vim.schedule(function()
                    vim.notify('compile_commands.json generated successfully!', vim.log.levels.INFO)
                    vim.notify('Restarting LSP...', vim.log.levels.INFO)
                    vim.cmd('LspRestart')
                end)
            else
                vim.schedule(function()
                    vim.notify('Failed to generate compile_commands.json', vim.log.levels.ERROR)
                    vim.notify('Make sure kernel is configured (.config exists)', vim.log.levels.WARN)
                    vim.notify('Try: make defconfig && make compile_commands.json', vim.log.levels.INFO)
                end)
            end
        end,
        on_stdout = function(_, data, _)
            if data then
                for _, line in ipairs(data) do
                    if line ~= '' then
                        print(line)
                    end
                end
            end
        end,
    })
end

-- Alternative: use scripts/clang-tools/gen_compile_commands.py
M.generate_compile_commands_alt = function()
    if not M.is_kernel_tree() then
        vim.notify('Not in a Linux kernel source tree', vim.log.levels.ERROR)
        return
    end

    local script = 'scripts/clang-tools/gen_compile_commands.py'
    if vim.fn.filereadable(script) == 0 then
        vim.notify('scripts/clang-tools/gen_compile_commands.py not found', vim.log.levels.ERROR)
        vim.notify('This kernel version may not support this script', vim.log.levels.WARN)
        return
    end

    vim.notify('Generating compile_commands.json (alternative method)...', vim.log.levels.INFO)

    vim.fn.jobstart('python3 ' .. script, {
        on_exit = function(_, exit_code, _)
            if exit_code == 0 then
                vim.schedule(function()
                    vim.notify('compile_commands.json generated!', vim.log.levels.INFO)
                    vim.cmd('LspRestart')
                end)
            else
                vim.schedule(function()
                    vim.notify('Failed to generate compile_commands.json', vim.log.levels.ERROR)
                end)
            end
        end,
    })
end

-- Create user commands
vim.api.nvim_create_user_command('KernelGenCompileCommands', M.generate_compile_commands, {
    desc = 'Generate compile_commands.json for Linux kernel (make method)'
})

vim.api.nvim_create_user_command('KernelGenCompileCommandsAlt', M.generate_compile_commands_alt, {
    desc = 'Generate compile_commands.json for Linux kernel (script method)'
})

-- Auto-detect kernel tree and show hint
vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
    pattern = {'*.c', '*.h'},
    callback = function()
        if M.is_kernel_tree() then
            -- Check if compile_commands.json exists
            if vim.fn.filereadable('compile_commands.json') == 0 then
                -- Only show once per session
                if not vim.g.kernel_hint_shown then
                    vim.g.kernel_hint_shown = true
                    vim.notify(
                        'Linux kernel detected! Run :KernelGenCompileCommands for LSP support',
                        vim.log.levels.INFO
                    )
                end
            end
        end
    end,
})

return M
