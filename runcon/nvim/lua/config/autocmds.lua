-- [[ Autocommands ]]

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
    desc = 'Highlight yanked text',
})

-- Set wraps when composing emails
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = { '*.mail', '*patch', '*.txt' },
    callback = function()
        vim.opt_local.textwidth = 72
    end,
    desc = 'Set textwidth for email and patches',
})

-- Resource tmux.conf file after saving it
vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = { '.tmux.conf', '.tmux.local.conf' },
    callback = function()
        vim.fn.system('tmux source-file ' .. vim.fn.expand('%'))
    end,
    desc = 'Reload tmux config after save',
})

-- If a file is already open, open it in RO mode
vim.api.nvim_create_autocmd('SwapExists', {
    callback = function()
        vim.v.swapchoice = 'o'
    end,
    desc = 'Open swapped files in read-only mode',
})

-- Disable syntax for rst files
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'rst',
    callback = function()
        vim.opt_local.syntax = 'off'
    end,
    desc = 'Disable syntax highlighting for RST files',
})

-- VimDiff settings
if vim.o.diff then
    vim.opt.cursorline = true
    vim.keymap.set('n', '.', ']c', { desc = 'Next diff' })
    vim.keymap.set('n', ',', '[c', { desc = 'Previous diff' })
end
