let g:netrw_liststyle = 3
syntax on
filetype plugin indent on


set number
set relativenumber
set cursorline

set wildmenu
set showcmd

set ignorecase
set smartcase

set hlsearch
set incsearch

set scrolloff=5
set wrap

set linebreak

set expandtab
set shiftwidth=2
set tabstop=4

set smartindent
set autoindent

" Save with Ctrl-S
nnoremap <C-s> :w<CR>
" Close buffer Ctrl-q
nnoremap <C-q> :bd<CR>

nnoremap <C-f> :NERDTreeFind<CR>
nnoremap <F4> :NERDTreeToggle<CR>

nnoremap <Leader>h :set hlsearch!<CR>
" vnoremap <Leader>gc :s/^/\/\//g<CR>
" vnoremap <Leader>gu :s/^\/\///g<CR>

call plug#begin('~/.vim/plugged')

" Add plugins here
Plug 'preservim/nerdtree'         " File explorer
Plug 'junegunn/fzf', {'do': './install --all'} " Fuzzy finder
Plug 'junegunn/fzf.vim'
Plug 'vim-airline/vim-airline'   " Status bar
Plug 'tpope/vim-commentary'      " Commenting utility

" color theme
Plug 'EdenEast/nightfox.nvim'


Plug 'preservim/tagbar'
call plug#end()

colorscheme slate


function! ToggleNumbers()
  if &number
    if &relativenumber
      set norelativenumber
    else
      set relativenumber
    endif
  endif
endfunction

nnoremap <F2> :call ToggleNumbers()<CR>


nnoremap <Leader>B :Buffers<CR>
nnoremap <Leader>F :Files<CR>
nnoremap <Leader>H :History:<CR>
nnoremap <Leader>M :Marks<CR>

set completeopt=menu,menuone,noselect

