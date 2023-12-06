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
vim.keymap.set('n', '<Bslash>o', ":%bd|e#|bd#<CR>", { desc = 'Close all [o]ther buffers'})

-- Physical Page-Up and Page-Down work as Ctrl-U/Ctrl-D
nnoremap('<PageUp>', '<C-U>')
nnoremap('<PageUp>', '<C-U>')
inoremap('<PageUp>', '<C-\\><C-O><C-U>')
xnoremap('<PageDown>', '<C-D>')
xnoremap('<PageDown>', '<C-D>')
inoremap('<PageDown>', '<C-\\><C-O><C-D>')

-- Disable EX mode
nnoremap('Q', '<Nop>')

-- Disable arrow key
-- for _, key in ipairs({'<Left>', '<Right>', '<Up>', '<Down>'}) do
--     nnoremap(key, '<Nop>')
--     xnoremap(key, '<Nop>')
-- end

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
