set number
set expandtab
set shiftwidth=2
set autoindent
set mouse=

call plug#begin('~/.local/share/nvim/plugged')

autocmd VimEnter * NvimTreeOpen
autocmd VimLeavePre * NvimTreeClose

nnoremap <C-S> :w<CR>:Format<CR>
inoremap <C-S> <Esc>:w<CR>:Format<CR>
nnoremap <F3> :set number!<CR>

" ファイルエクスプローラ
Plug 'kyazdani42/nvim-tree.lua'
nnoremap nn :NvimTreeToggle<CR>
nnoremap nf :NvimTreeFindFile<CR>
nnoremap <A-j> :vertical resize +5<CR>
nnoremap <A-k> :vertical resize -5<CR>

" TypeScript用のシンタックスハイライトとLSPサポート
Plug 'leafgarland/typescript-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

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

" UltiSnips
Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<tab>"

" formatter
Plug 'mhartington/formatter.nvim'

call plug#end()

" coc.nvimの設定
let g:coc_global_extensions = ['coc-tsserver', 'coc-json', 'coc-html', 'coc-css']
inoremap <silent><expr> <CR> pumvisible() ? coc#pum#confirm(): "\<CR>"

lua << EOF
require'plugins'
require('telescope').setup{
  defaults = {
    file_ignore_patterns = {'.git/', 'node_modules/'},
    vimgrep_arguments = { "rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--smart-case", "--column", "-uu", "-i"},
    extensions = { fzf = { fuzzy = true, override_generic_sorter = true, override_file_sorter = true, case_mode = "smart_case" }   },
  },
}
require('telescope').load_extension('fzf')
require('telescope').load_extension('frecency')
require('formatter').setup({
  filetype = {
    javascript = {require("formatter.filetypes.javascript").biome},
    typescript = {require("formatter.filetypes.typescript").biome},
    vue = {require("formatter.filetypes.vue").biome},
  },
})
EOF
