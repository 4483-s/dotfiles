set relativenumber number
set hlsearch
set incsearch
set cursorline
"set cursorcolumn

syntax on
imap jj <Esc>

" focus window
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" Y yank from cursor to the end of line
nnoremap Y y$

nnoremap j gj
nnoremap k gk

let mapleader = " "
nnoremap <leader>h :noh<CR>
autocmd FileType yaml setlocal et ai ts=2 sw=2
