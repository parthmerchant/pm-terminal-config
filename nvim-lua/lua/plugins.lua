local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('preservim/nerdtree', {on = 'NERDTreeToggle'})
Plug('vim-airline/vim-airline')
Plug('vim-airline/vim-airline-themes')
Plug('catppuccin/nvim', { as = 'catppuccin' })
Plug('sindrets/diffview.nvim')
Plug('davidhalter/jedi-vim')
Plug('Shougo/deoplete.nvim')
Plug('fatih/vim-go', { ['do'] = ':GoUpdateBinaries' })
Plug('iamcco/markdown-preview.nvim', { ['do'] = 'cd app && npx --yes yarn install' })
Plug('nvim-tree/nvim-web-devicons')
Plug('ryanoasis/vim-devicons')
Plug('Vimjas/vim-python-pep8-indent')
Plug('parthmerchant/gruvbox')
vim.call('plug#end')

