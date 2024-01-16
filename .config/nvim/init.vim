set number
set expandtab
set shiftwidth=2
set autoindent

call plug#begin('~/.local/share/nvim/plugged')

" ファイルエクスプローラ
Plug 'kyazdani42/nvim-tree.lua'
nnoremap <C-n> :NvimTreeToggle<CR>

" TypeScript用のシンタックスハイライトとLSPサポート
Plug 'leafgarland/typescript-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" coc.nvimの設定
let g:coc_global_extensions = ['coc-tsserver', 'coc-json', 'coc-html', 'coc-css']

lua require'plugins'
