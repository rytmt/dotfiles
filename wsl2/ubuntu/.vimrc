" --------------------------------------------------
" Encode
" --------------------------------------------------
set encoding=UTF-8
set fileencoding=UTF-8
set fileencodings=utf-8,cp932,euc-jp,utf-16le
set fileformat=unix
set fileformats=unix,dos
set termencoding=UTF-8


" --------------------------------------------------
" File
" --------------------------------------------------
set hidden
set autoread
set backup
set swapfile
set undofile
set backupdir=$HOME/.vim/backup
set undodir=$HOME/.vim/undo
set directory=$HOME/.vim/swp
set viminfo=


" --------------------------------------------------
" Search
" --------------------------------------------------
set incsearch
set hlsearch
set smartcase
set ignorecase
set wrapscan


" --------------------------------------------------
" Input
" --------------------------------------------------
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
set nrformats=
inoremap <C-a> <Home>
inoremap <C-e> <End>
autocmd InsertLeave * set nopaste

" --------------------------------------------------
" Display
" --------------------------------------------------
syntax on
set number
set title
set showcmd
set cmdheight=2
set ruler
set showmatch
set list
"set listchars=eol:¬,tab:>
set listchars=eol:¬,tab:»\
set wrap
set cursorline
set background=dark
set matchtime=3
set laststatus=2
set statusline=%y
set visualbell t_vb=
set statusline=%{expand('%:p:t')}\ %<[%{expand('%:p:h')}]%=\ %m%r%y%w[%{&fenc!=''?&fenc:&enc}][%{&ff}][%3l,%3c,%3p]


" --------------------------------------------------
" Mail
" --------------------------------------------------
autocmd FileType mail highlight mailQuoted1 ctermfg=4
autocmd FileType mail highlight mailQuoted2 ctermfg=2
autocmd FileType mail highlight mailQuoted3 ctermfg=6
autocmd FileType mail highlight mailQuoted4 ctermfg=3
autocmd FileType mail highlight mailQuoted5 ctermfg=13
autocmd FileType mail set textwidth=64
autocmd FileType mail set formatoptions=qmMw
autocmd FileType mail set ambiwidth=double



" --------------------------------------------------
" ColorScheme
" --------------------------------------------------
"colorscheme solarized
"colorscheme gruvbox
let g:gruvbox_material_background = 'soft'
colorscheme gruvbox-material



" --------------------------------------------------
" Background Transparent
" --------------------------------------------------
highlight Normal ctermbg=none
highlight NonText ctermbg=none
highlight LineNr ctermbg=none
highlight Folded ctermbg=none
highlight EndOfBuffer ctermbg=none



" --------------------------------------------------
" Plugin
" --------------------------------------------------
