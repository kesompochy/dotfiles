set number
set expandtab
set shiftwidth=2
set autoindent

call plug#begin('~/.local/share/nvim/plugged')

autocmd VimEnter * NvimTreeOpen
autocmd VimLeavePre * NvimTreeClose

nnoremap <C-S> :w<CR>
inoremap <C-S> <Esc>:w<CR>

" ファイルエクスプローラ
Plug 'kyazdani42/nvim-tree.lua'
nnoremap nn :NvimTreeToggle<CR>
nnoremap nf :NvimTreeFindFile<CR>

" TypeScript用のシンタックスハイライトとLSPサポート
Plug 'leafgarland/typescript-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" git
Plug 'tpope/vim-fugitive'
nnoremap gg :G<CR>
nnoremap gc :G commit<CR>
nnoremap gd :G diff<CR>

call plug#end()

" coc.nvimの設定
let g:coc_global_extensions = ['coc-tsserver', 'coc-json', 'coc-html', 'coc-css']

lua require'plugins'
