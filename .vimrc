"-----------------------------------------------------------------------------------------------------------------------
"
" Intallation instructions
"
" --- Install Vundle
" git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
"-----------------------------------------------------------------------------------------------------------------------

set nocompatible " required
filetype off " required

"-----------------------------------------------------------------------------------------------------------------------
" Set the runtime path to include Vundle and initialize
"-----------------------------------------------------------------------------------------------------------------------

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"-------- Vundle -------------------------------------------------------------------------------------------------------

Plugin 'VundleVim/Vundle.vim'

"-------- Fonts and colors ---------------------------------------------------------------------------------------------

Plugin 'morhetz/gruvbox'

"-------- Code/project navigation --------------------------------------------------------------------------------------

Plugin 'terryma/vim-expand-region'
Plugin 'scrooloose/nerdtree'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'easymotion/vim-easymotion'
Plugin 'vim-airline/vim-airline'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'rking/ag.vim'

"-------- Performance --------------------------------------------------------------------------------------------------

Plugin 'jiangmiao/auto-pairs'
Plugin 'mattn/emmet-vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-sensible'
Plugin 'tmhedberg/SimpylFold'

"-------- Snippets -----------------------------------------------------------------------------------------------------

Plugin 'honza/vim-snippets'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'

"-------- GIT support --------------------------------------------------------------------------------------------------

Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

"-------- Languages and frameworks -------------------------------------------------------------------------------------

Plugin 'vim-syntastic/syntastic'
Plugin 'elzr/vim-json'

" !!! All of your Plugins must be added before the following line

call vundle#end() " required

filetype on	" required
filetype plugin on " required
filetype plugin indent on " required

"------- Editor Settings -----------------------------------------------------------------------------------------------

" Automatically reload vimrc when it's saved
au BufWritePost .vimrc so ~/.vimrc

" Disable backup and swap fils
set nobackup
set nowritebackup
set noswapfile

" Split layouts
set splitbelow
set splitright

" Switch between nuffers
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Clipboard settings
set clipboard=unnamed

" Enable syntax
syntax on
let python_highlight_all=1

" Set file encoding
set encoding=utf-8

" Color scheme
" set t_Co=256
" colorscheme jellybeans
" colorscheme vwilight
colorscheme gruvbox
set background=dark

" Autohighlight searched words
set hlsearch
set incsearch
set ignorecase
set smartcase
set cursorline

" Enable line numbers
set nu

" Add the proper indentation
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Highlight coursor row in insert mode
:autocmd InsertEnter * set cul
:autocmd InsertLeave * set nocul

" Decrease update time
set updatetime=250

" Folding
set foldmethod=indent
set foldlevel=99
nnoremap <space> za
let g:SimpylFold_docstring_preview=1

" Allows you to enter sudo pass and save the file
" when you forgot to open your file with sudo
cmap w!! %!sudo tee > /dev/null %

"------- Easymotion Settings -------------------------------------------------------------------------------------------

map <Leader> <Plug>(easymotion-prefix)

"------- NERDTree Settings ---------------------------------------------------------------------------------------------

map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore=['\.pyc$', '\~$'] " ignore *.pyc files" Enable folding
let NERDTreeShowHidden=1
nmap <C-\> :NERDTreeFind<CR>

"------- Syntastic Settings --------------------------------------------------------------------------------------------

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"------- JSX Settings --------------------------------------------------------------------------------------------------

let g:jsx_ext_required = 0 " Allow JSX in normal JS files

"------- JS Formatter --------------------------------------------------------------------------------------------------

map <c-f> :call JsBeautify()<cr>
