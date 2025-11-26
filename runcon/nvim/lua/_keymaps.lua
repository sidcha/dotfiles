-- [[ Basic Keymaps ]]

local nnoremap = function(lhs, rhs)
    vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true, silent = true })
end

local inoremap = function(lhs, rhs)
    vim.api.nvim_set_keymap('i', lhs, rhs, { noremap = true, silent = true })
end

local xnoremap = function(lhs, rhs)
    vim.api.nvim_set_keymap('x', lhs, rhs, { noremap = true, silent = true })
end

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- Working with buffers
vim.keymap.set('n', '<Bslash>[', ":bprevious<CR>", { desc = 'Move to previous open buffer' })
vim.keymap.set('n', '<Bslash>]', ":bnext<CR>", { desc = 'Move to next open buffer' })
vim.keymap.set('n', '<Bslash>q', ":bp <BAR> bd #<CR>", { desc = 'Close current buffer and move to previous' })
vim.keymap.set('n', '<Bslash>o', ":%bd|e#|bd#<CR>", { desc = 'Close all [o]ther buffers'})

-- Physical Page-Up and Page-Down work as Ctrl-U/Ctrl-D
nnoremap('<PageUp>', '<C-U>')
nnoremap('<PageUp>', '<C-U>')
inoremap('<PageUp>', '<C-\\><C-O><C-U>')
xnoremap('<PageDown>', '<C-D>')
xnoremap('<PageDown>', '<C-D>')
inoremap('<PageDown>', '<C-\\><C-O><C-D>')

-- Remap Shift + Up/Down to behave like normal Up/Down
nnoremap('<S-Up>', '<Up>')
nnoremap('<S-Down>', '<Down>')

-- Disable EX mode
nnoremap('Q', '<Nop>')

-- Disable arrow key
-- for _, key in ipairs({'<Left>', '<Right>', '<Up>', '<Down>'}) do
--     nnoremap(key, '<Nop>')
--     xnoremap(key, '<Nop>')
-- end

-- Remap vertical selection to <c-q>
nnoremap('<C-q>', '<C-v>')

-- Go to middle of a line
vim.keymap.set('n', 'gm', function()
    vim.fn.cursor(0, math.floor(vim.fn.virtcol('$') / 2))
end, { desc = 'Go to middle of line' })

-- Disable command line history browser
vim.keymap.set('n', 'q:', '<Nop>')

-- Command aliases to help solve the :Wq annoyance
vim.api.nvim_create_user_command('WQ', 'wq', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Q', 'q', {})

-- TrimWhiteSpace function
local function trim_whitespace()
    local save_cursor = vim.fn.getpos('.')
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos('.', save_cursor)
end

-- Function key mappings
vim.keymap.set('n', '<F2>', trim_whitespace, { desc = 'Trim trailing whitespace' })
vim.keymap.set('n', '<F3>', function()
    vim.wo.number = not vim.wo.number
    vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = 'Toggle line numbers' })
vim.keymap.set('n', '<F4>', function()
    vim.wo.wrap = not vim.wo.wrap
end, { desc = 'Toggle line wrap' })
vim.keymap.set('n', '<F5>', function()
    vim.wo.spell = not vim.wo.spell
end, { desc = 'Toggle spell check' })
vim.keymap.set('n', '<F6>', ':Git blame<CR>', { desc = 'Git blame' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- Set wraps when composing emails
vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
    pattern = {'*.mail', '*patch', '*.txt'},
    callback = function()
        vim.opt_local.textwidth = 72
    end,
})

-- Resource tmux.conf file after saving it
vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = {'.tmux.conf', '.tmux.local.conf'},
    callback = function()
        vim.fn.system('tmux source-file ' .. vim.fn.expand('%'))
    end,
})

-- If a file is already open, open it in RO mode
vim.api.nvim_create_autocmd('SwapExists', {
    callback = function()
        vim.v.swapchoice = 'o'
    end,
})

-- Disable syntax for rst files
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'rst',
    callback = function()
        vim.opt_local.syntax = 'off'
    end,
})

-- VimDiff settings
if vim.o.diff then
    vim.opt.cursorline = true
    vim.keymap.set('n', '.', ']c', { desc = 'Next diff' })
    vim.keymap.set('n', ',', '[c', { desc = 'Previous diff' })
end
