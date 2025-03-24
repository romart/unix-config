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

" Git support
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'rhysd/git-messenger.vim'


" Shell support
" Plug 'voldikss/vim-floaterm'
Plug 'tpope/vim-dispatch'

" C/C++ support
" Plug 'vim-scripts/c.vim'
" Plug 'ludovicchabant/vim-gutentags'
Plug 'ycm-core/YouCompleteMe'
Plug 'preservim/tagbar'
Plug 'puremourning/vimspector'
call plug#end()

" sudo apt-get install vim-gui-common
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


let g:gutentags_ctags_executable = 'ctags'
let g:gutentags_project_root = ['.git', '.hg', '.svn', 'Makefile']
let g:gutentags_generate_on_write = 1

let g:ycm_clangd_args = ['--log=verbose']

set path+=**,./include

" YouCompleteMe setting up
nnoremap <Leader>gd :YcmCompleter GoTo<CR>         " Go to definition
nnoremap <Leader>gr :YcmCompleter GoToReferences<CR> " Find references
nnoremap <Leader>gi :YcmCompleter GoToImplementation<CR> " Go to implementation
nnoremap <Leader>dd :YcmCompleter GetDoc<CR>       " Show documentation

noremap <F12> :TagbarToggle<CR> " Show list of declarations 

nnoremap <Leader>B :Buffers<CR>

" let g:ycm_goto_buffer_command = 'current'

" let g:ycm_enable_preview = 0
" let g:ycm_auto_trigger = 0

nmap <F5> :call vimspector#Launch()<CR>
nmap <Leader>C :call vimspector#Continue()<CR>
nmap <F9> :call vimspector#ToggleBreakpoint()<CR>
nmap <F10> :call vimspector#StepOver()<CR>
nmap <F11> :call vimspector#StepInto()<CR>
nmap <S-F11> :call vimspector#StepOut()<CR>
nmap <Leader>R :VimspectorReset<CR>
nmap <Leader>P :call vimspector#Pause()<CR>
              

set completeopt=menu,menuone,noselect

