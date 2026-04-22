local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('preservim/nerdtree', {on = 'NERDTreeToggle'})
Plug('vim-airline/vim-airline')
Plug('vim-airline/vim-airline-themes')
Plug('catppuccin/nvim', { as = 'catppuccin' })
Plug('sindrets/diffview.nvim')
Plug('fatih/vim-go', { ['do'] = ':GoUpdateBinaries' })
Plug('iamcco/markdown-preview.nvim', { ['do'] = 'cd app && npx --yes yarn install' })
Plug('nvim-tree/nvim-web-devicons')
Plug('ryanoasis/vim-devicons')
Plug('Vimjas/vim-python-pep8-indent')
Plug('nvim-telescope/telescope.nvim')
Plug('nvim-treesitter/nvim-treesitter')
Plug('nvim-lua/plenary.nvim')
Plug('akinsho/toggleterm.nvim')
Plug('sainnhe/everforest')

-- LSP + autocomplete stack (Python via pyright; see lua/python_lsp.lua).
-- jedi-vim and deoplete were removed to prevent conflicting completions.
Plug('neovim/nvim-lspconfig')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('L3MON4D3/LuaSnip', { ['do'] = 'make install_jsregexp' })
Plug('saadparwaiz1/cmp_luasnip')

-- Avante required deps (you already have plenary above)
Plug('MunifTanjim/nui.nvim')
Plug('MeanderingProgrammer/render-markdown.nvim')

-- Optional deps (keep whatever you want)
Plug('HakonHarnes/img-clip.nvim')
Plug('zbirenbaum/copilot.lua')
Plug('stevearc/dressing.nvim')
--Plug('folke/snacks.nvim')

-- Avante (build with make)
Plug('yetone/avante.nvim', { ['do'] = 'make' })
Plug('greggh/claude-code.nvim')

vim.call('plug#end')
