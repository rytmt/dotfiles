" Not compatible with vi
set nocompatible


" Disable default plugins
" -----------------------
let g:loaded_gzip              = 1
let g:loaded_tar               = 1
let g:loaded_tarPlugin         = 1
let g:loaded_zip               = 1
let g:loaded_zipPlugin         = 1
let g:loaded_rrhelper          = 1
let g:loaded_2html_plugin      = 1
let g:loaded_vimball           = 1
let g:loaded_vimballPlugin     = 1
let g:loaded_getscript         = 1
let g:loaded_getscriptPlugin   = 1
let g:loaded_netrw             = 1
let g:loaded_netrwPlugin       = 1
let g:loaded_netrwSettings     = 1
let g:loaded_netrwFileHandlers = 1


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
set backupdir=C:\applications\vimtmp\backup
set undodir=C:\applications\vimtmp\undo
set directory=C:\applications\vimtmp\swp
set viminfo+=nC:/applications/vimtmp/_viminfo


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
nnoremap <S-j> 10j
nnoremap <S-k> 10k
nnoremap <S-h> 10h
nnoremap <S-l> 10l
nnoremap <C-n> :bn<CR>
nnoremap <C-p> :bp<CR>
inoremap <C-a> <Home>
inoremap <C-e> <End>


" Display
" -------
syntax on
set number
set title
set showcmd
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
set visualbell t_vb=
augroup highlightIdeographicSpace
  autocmd!
  autocmd Colorscheme * highlight IdeographicSpace term=underline ctermbg=DarkGray guibg=#444444
  autocmd Colorscheme * highlight HeadNormalSpace term=underline ctermbg=DarkGray guibg=#222244
  autocmd Colorscheme * highlight TailNormalSpace term=underline ctermbg=DarkGray guibg=#222244
  autocmd VimEnter,WinEnter * match IdeographicSpace /　/
  autocmd VimEnter,WinEnter * 2match HeadNormalSpace /\v^ +/
  autocmd VimEnter,WinEnter * 3match TailNormalSpace /\v +$/
augroup END

" Status Line
" -----------
" let ff_table = {'dos' : 'CR+LF', 'unix' : 'LF', 'mac' : 'CR' }
" let &statusline='%<%f %h%m%r%w%=[%{(&fenc!=""?&fenc:&enc)}:%{ff_table[&ff]}]%y%= %-14.(%l,%c%V%) %P'
" augroup InsertHook
" autocmd!
" autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
" autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
" augroup END


" Check colors
" :so $VIMRUNTIME/syntax/colortest.vim


" Tabpage
" -------
nnoremap <C-t> :tablast <bar> tabnew<CR>
nnoremap <C-Tab> gt
nnoremap <C-S-Tab> gT


" Session
" -------
set sessionoptions=buffers
nnoremap :mks :mksession! C:\applications\vim74-kaoriya-win64\Session.vim<CR>
nnoremap :rds :source C:\applications\vim74-kaoriya-win64\Session.vim<CR>


" Others
" ------
filetype plugin indent on
set runtimepath+=C:\applications\vim74-kaoriya-win64\vimfiles\\*
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif


" Unite.vim
" ---------
nnoremap <S-u>t :Unite tab<CR>
nnoremap <S-u>r :Unite register<CR>
nnoremap <S-u>g :Unite -no-quit vimgrep<CR>
nnoremap <S-q> :Unite buffer -no-quit -keep-focus<CR>:set number<CR>
"nnoremap <S-u>f :Unite file_mru<CR>
nnoremap <S-u>f :MRU<CR>
nnoremap <S-u>y :Unite history/yank<CR>


" lightline.vim
" -------------
let g:lightline = {
\  'colorscheme': 'jellybeans',
\  'separator': { 'left': "", 'right': "" }
\}


" neocomplete.vim
" -----------------
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_ignore_case = 1
let g:neocomplete#enable_smart_case = 1
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns._ = '\h\w*'
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"


" im_control.vim
" --------------
let IM_CtrlMode = 4    " but this option is default in Windows


" vim-easymotion.vim
" ------------------
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_use_migemo = 1
" nmap s <plug>(easymotion-s2)
" nmap g/ <Plug>(easymotion-sn)
nmap s <Plug>(easymotion-sn)


" clever-f.vim
" ------------
let g:clever_f_use_migemo = 1
let g:clever_f_smart_case = 1


" JpFormat.vim
" ------------
au BufRead *.eml JpSetAutoFormat!
au BufRead,BufNewFile *.eml let JpFormatCursorMovedI=1
au BufRead,BufNewFile *.eml let b:JpCountChars=32


" MRU
" ---
let MRU_Max_Entries = 100
let MRU_Exclude_Files = ".*\.eml$"
let MRU_Window_Height = 30


" Startify
" --------
"let g:startify_files_number = 100
"let g:startify_custom_header = ['> Startify']
"let g:startify_list_order = [['> Most Recently Used'],'files']


" Use cygwin bash
" ---------------
set shell=C:\cygwin64\bin\bash
set shellcmdflag=--login\ -c
set shellxquote=\" 


" :function! MailDomain()
" :  let to_line = getline(2)
" :  let cc_line = getline(3)
" :  let to_addrs = substitute(to_line,"To:        ","","g")
" :  let cc_addrs = substitute(cc_line,"Cc:        ","","g")
" :endfunction
