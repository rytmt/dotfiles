" Not compatible with vi
set nocompatible


" FileType
" --------
"  NOTE: Need 'let g:no_vimrc_example = 1' in vimrc file and 'plugin indent on' in _vimrc file.
filetype off
filetype plugin indent off


" Encode
" ------
set encoding=UTF-8
set fileencoding=UTF-8
set termencoding=UTF-8
set fileencodings=utf-8,cp932,euc-jp,utf-16le
set fileformats=unix,dos


" File
" ----
set hidden
set autoread
set backup
set swapfile
set undofile
set backupdir=~/.vimtmp
set undodir=~/.vimtmp
set directory=~/.vimtmp


" Search
" ------
set incsearch
set hlsearch
set smartcase
set ignorecase
set wrapscan


" Input
" -----
set cindent
set shiftwidth=4
set tabstop=4
set expandtab
set softtabstop=4
set backspace=indent,eol,start
set whichwrap=b,s,h,l,<,>,[,]
set clipboard=unnamed
set textwidth=0
set formatoptions=q
nnoremap x "_x
nnoremap Y v$hy
nnoremap yl ^v$hy
nnoremap <S-j> 10j
nnoremap <S-k> 10k
nnoremap <S-h> 10h
nnoremap <S-l> 10l
nnoremap <C-n> :bn<CR>
nnoremap <C-p> :bp<CR>
nnoremap <C-s> :w<CR>
nnoremap <C-q> :bw!<CR>
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-u> <esc>ui
inoremap <C-r> <esc><C-r>i
inoremap <C-s> <esc>:w<CR>
inoremap <C-q> <esc>:bw!<CR>


" Display
" -------
syntax on
set number
set title
set showcmd
set ruler
set showmatch
set list
set listchars=eol:¬,tab:»\ 
set wrap
set cursorline
set background=dark
set matchtime=3
set laststatus=2
set visualbell t_vb=


augroup highlightIdegraphicSpace
  autocmd!
  autocmd Colorscheme * highlight IdeographicSpace term=underline ctermbg=DarkGray guibg=#444444
  autocmd VimEnter,WinEnter * match IdeographicSpace /　/
augroup END


colorscheme jellybeans
highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE
