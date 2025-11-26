-- [[ Core Keymaps ]]
-- Keymaps that are not plugin-specific

-- Helper functions for legacy mappings
local nnoremap = function(lhs, rhs)
    vim.api.nvim_set_keymap('n', lhs, rhs, { noremap = true, silent = true })
end

local inoremap = function(lhs, rhs)
    vim.api.nvim_set_keymap('i', lhs, rhs, { noremap = true, silent = true })
end

local xnoremap = function(lhs, rhs)
    vim.api.nvim_set_keymap('x', lhs, rhs, { noremap = true, silent = true })
end

-- Disable space in normal/visual mode (leader key)
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Better word wrap navigation
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic error' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostics quickfix list' })

-- Buffer navigation
vim.keymap.set('n', '<Bslash>[', ':bprevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<Bslash>]', ':bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<Bslash>q', ':bp <BAR> bd #<CR>', { desc = 'Close buffer' })
vim.keymap.set('n', '<Bslash>o', ':%bd|e#|bd#<CR>', { desc = 'Close other buffers' })

-- Physical Page-Up and Page-Down work as Ctrl-U/Ctrl-D
nnoremap('<PageUp>', '<C-U>')
inoremap('<PageUp>', '<C-\\><C-O><C-U>')
xnoremap('<PageUp>', '<C-U>')
nnoremap('<PageDown>', '<C-D>')
inoremap('<PageDown>', '<C-\\><C-O><C-D>')
xnoremap('<PageDown>', '<C-D>')

-- Remap Shift + Up/Down to behave like normal Up/Down
nnoremap('<S-Up>', '<Up>')
nnoremap('<S-Down>', '<Down>')

-- Disable EX mode
nnoremap('Q', '<Nop>')

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

-- Utility functions
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
