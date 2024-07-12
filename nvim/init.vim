set encoding=utf-8
set number relativenumber
set clipboard+=unnamedplus
call plug#begin()
	" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.1' }
" or                                , { 'branch': '0.1.x' }

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'nanozuki/tabby.nvim'
" On-demand loading
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

Plug 'navarasu/onedark.nvim'
Plug 'ryanoasis/vim-devicons'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Using a non-default branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }


" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }

Plug 'preservim/nerdtree'

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

""Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-tree/nvim-web-devicons' " Recommended (for coloured icons)
" Plug 'ryanoasis/vim-devicons' Icons without colours
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }

Plug 'akinsho/toggleterm.nvim', {'tag' : '*'}
" lua & third party sources -- See https://github.com/ms-jpq/coq.thirdparty
" Need to **configure separately**

"Plug 'zchee/deoplete-jedi' " Python autocompletion
"Plug 'tell-k/vim-autopep8' "autopep8
"Plug 'davidhalter/jedi-vim' " Just to add the python go-to-definition and similar features, autocompletion
"Plug 'Shougo/deoplete.nvim' "Async autocompletion
"Plug 'ncm2/ncm2'  " awesome autocomplete plugin
"Plug 'ncm2/ncm2-bufword'  " buffer keyword completion

" Unmanaged plugin (manually installed and updated)
Plug '~/my-prototype-plugin'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'camspiers/snap'
" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting

map <C-f> :Telescope find_files<CR>
map <C-t> :NERDTreeToggle<CR>
map <C-n> :tabnew<CR>
map <C-b> :-tabnext<CR>
map <C-v> :+tabnext<CR>
map <C-l> :ToggleTerm<CR>
" let g:airline_theme='luna'
let g:airline_solarized_bg='dark'
lua require("toggleterm").setup()
let g:airline_powerline_fonts = 1
let laststatus=2
" loading the plugin
let g:webdevicons_enable = 1
" adding the flags to NERDTree
let g:webdevicons_enable_nerdtree = 1
" Vim
let g:airline#extensions#tabline#enabled = 1
set signcolumn=no
""" Customize colors
func! s:my_colors_setup() abort
    " this is an example
    hi Pmenu guibg=#d7e5dc gui=NONE
    hi PmenuSel guibg=#b7c7b7 gui=NONE
    hi PmenuSbar guibg=#bcbcbc
    hi PmenuThumb guibg=#585858
endfunc

augroup colorscheme_coc_setup | au!
    au ColorScheme * call s:my_colors_setup()
augroup END
