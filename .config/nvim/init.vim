set number
set expandtab
set shiftwidth=2
set autoindent
set mouse=

call plug#begin('~/.local/share/nvim/plugged')

autocmd VimEnter * NvimTreeOpen
autocmd VimLeavePre * NvimTreeClose

nnoremap <C-S> :w<CR>
inoremap <C-S> <Esc>:w<CR>

" ファイルエクスプローラ
Plug 'kyazdani42/nvim-tree.lua'
nnoremap nn :NvimTreeToggle<CR>
nnoremap nf :NvimTreeFindFile<CR>
nnoremap nfc :NvimTreeFocus<CR>:lua require'nvim-tree.api'.fs.create()<CR>
nnoremap nfd :NvimTreeFocus<CR>:lua require'nvim-tree.api'.fs.remove()<CR>
nnoremap nfr :NvimTreeFocus<CR>:lua require'nvim-tree.api'.fs.rename_node()<CR>

" TypeScript用のシンタックスハイライトとLSPサポート
Plug 'leafgarland/typescript-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" git
Plug 'tpope/vim-fugitive'
nnoremap gg :G<CR>
nnoremap gc :G commit<CR>
nnoremap gd :G diff<CR>


" telescope.nvim
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }
Plug 'nvim-telescope/telescope-frecency.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
nnoremap <C-p> :Telescope find_files hidden=true<CR>
nnoremap <C-f> :Telescope live_grep<CR>
nnoremap <C-b> :Telescope buffers<CR>
nnoremap <C-g> :Telescope git_status<CR>

call plug#end()

" coc.nvimの設定
let g:coc_global_extensions = ['coc-tsserver', 'coc-json', 'coc-html', 'coc-css']

lua << EOF
require'plugins'
require('telescope').setup{
  defaults = {
    file_ignore_patterns = {'.git/'},
    vimgrep_arguments = { "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--smart-case", "--column", "-uu"},
    extensions = { fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case" }   },
  },
}
require('telescope').load_extension('fzf')
require('telescope').load_extension('frecency')
EOF
