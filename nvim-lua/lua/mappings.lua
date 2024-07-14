vim.keymap.set('n', '<space>w', '<cmd>write<cr>', {desc = 'Save'})
vim.keymap.set('n', '<C-q>', ':NERDTreeToggle<CR>', {desc = 'Toggle Nerd Tree'})
vim.keymap.set('n', '<leader>w', '<cmd>write<cr>')
vim.keymap.set('n', '<C-f>', ':Telescope find_files<CR>')
vim.keymap.set('n', '<C-n>', ':tabnew<CR>')
vim.keymap.set('n', '<C-b>', ':-tabnext<CR>')
vim.keymap.set('n', '<C-m>', ':+tabnext<CR>')
vim.keymap.set('n', '<C-l>', ':ToggleTerm<CR>')

