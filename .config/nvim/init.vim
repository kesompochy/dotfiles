set number
set expandtab
set shiftwidth=2
set autoindent
set mouse=
set clipboard&
set clipboard^=unnamedplus

call plug#begin('~/.local/share/nvim/plugged')

autocmd VimEnter * NvimTreeOpen
autocmd VimLeavePre * NvimTreeClose

nnoremap <F3> :set number!<CR>

nnoremap <silent> <leader>m :%s/\r//g<CR> " 改行コードを削除 leaderのデフォルト値はバックスラッシュ\

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

" telescope.nvim
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

" Copilot
Plug 'nvim-lua/plenary.nvim'
Plug 'CopilotC-Nvim/CopilotChat.nvim'
Plug 'github/copilot.vim'

call plug#end()

" WSL環境でのIME自動切り替え設定
if !empty($WSL_DISTRO_NAME)
  autocmd InsertLeave * silent! !~/.local/bin/zenhan.exe 0
  autocmd CmdlineLeave * silent! !~/.local/bin/zenhan.exe 0
  " NormalモードでEscを押した時も半角に切り替え
  nnoremap <silent> <Esc> <Esc>:silent! !~/.local/bin/zenhan.exe 0<CR>
endif

" coc.nvimの設定
let g:coc_global_extensions = ['coc-tsserver', 'coc-json', 'coc-html', 'coc-css']
inoremap <silent><expr> <CR> pumvisible() ? coc#pum#confirm(): "\<CR>"

" autoread external changes
set autoread
augroup AutoRead
  autocmd!
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() !=# 'c' | checktime | endif
augroup END

" auto checktime timer
if has('timers')
  call timer_start(3000, {-> execute('checktime')}, {'repeat': -1})
endif

lua << EOF
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
-- format on save
local grp = vim.api.nvim_create_augroup('FormatOnSave', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
  group = grp,
  pattern = '*',
  command = 'silent! Format',
})
require('nvim-tree').setup({
  filters = {
    git_ignored = false,
    custom = {
      "^\\.git$",
    },
  },
})
EOF
