" --------------------------------------------------
" Following settings depend on local filesystem
" --------------------------------------------------
" 
" File Section
"   - backupdir
"   - undodir
"   - directory
"   - viminfo
"
" Session Section
"   - mapping 'mks'
"   - mapping 'rds'
"
" Misc Section
"   - runtimepath
"
" External cooperation Section
"   - shell
"
" --------------------------------------------------


" --------------------------------------------------
" Uncompatible with vi
" --------------------------------------------------
set nocompatible



" --------------------------------------------------
" Disable default plugins
" --------------------------------------------------
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
"let g:loaded_netrw             = 1
"let g:loaded_netrwPlugin       = 1
"let g:loaded_netrwSettings     = 1
"let g:loaded_netrwFileHandlers = 1



" --------------------------------------------------
" FileType
" --------------------------------------------------
"  NOTE: Need 'let g:no_vimrc_example = 1' in vimrc file and 'plugin indent on' in _vimrc file.
filetype off
filetype plugin indent off



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
set backupdir=C:\applications\vimtmp\backup
set undodir=C:\applications\vimtmp\undo
set directory=C:\applications\vimtmp\swp
set viminfo+=nC:/applications/vimtmp/_viminfo



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
nnoremap x "_x
nnoremap Y v$hy
nnoremap ya :call YankLineWithoutCR()<CR>
nnoremap <S-j> 10j
nnoremap <S-k> 10k
nnoremap <S-h> 10h
nnoremap <S-l> 10l
nnoremap <A-j> 10j
nnoremap <A-k> 10k
nnoremap <A-h> 10h
nnoremap <A-l> 10l
nnoremap <C-n> :tabnext<CR>
nnoremap <C-p> :tabprevious<CR>
nnoremap <C-t> :tabedit %<CR>
nnoremap <C-s> :w<CR>
nnoremap <C-q> :bw!<CR>
nnoremap <C-e> :%y<CR>:tabnew<CR>p:%!
nnoremap <S-u>e :Explore "%:h"<CR>
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-u> <Esc>ui
inoremap <C-r> <Esc><C-r>i
inoremap <C-s> <Esc>:w<CR>
inoremap <C-q> <Esc>:bw!<CR>
"cnoremap fpath :echo expand("%:p")<CR>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
vunmap <C-x>

" yank current cursor line without \n
function! YankLineWithoutCR()
    call feedkeys(":let row = line('.')\<CR>")
    call feedkeys(":let col = col('.')\<CR>")
    call feedkeys("^y$")
    call feedkeys(":call cursor(row, col)\<CR>")
    call feedkeys(":echo @\"\<CR>")
endfunction

" for email(.eml) file
au BufRead,BufNewFile *.eml nnoremap <C-q> :q<CR>



" --------------------------------------------------
" Command
" --------------------------------------------------
command! Fpath :echo expand("%:p")
command! DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis



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
set visualbell t_vb=
let g:netrw_liststyle = 1
augroup highlightSpace
  autocmd!
  autocmd Colorscheme * highlight IdeographicSpace guibg=#444444
  autocmd Colorscheme * highlight NormalSpace  gui=underline guifg=#663333
  autocmd VimEnter,WinEnter * match IdeographicSpace /　/
  autocmd VimEnter,WinEnter * 2match NormalSpace /\v(^\s+|\s+$)/
augroup END

" Check colors
" :so $VIMRUNTIME/syntax/colortest.vim



" --------------------------------------------------
" Session
" --------------------------------------------------
set sessionoptions=buffers,tabpages
cnoremap mks :mksession! C:\applications\vim74-kaoriya-win64\Session.vim<CR>
cnoremap rds :source C:\applications\vim74-kaoriya-win64\Session.vim<CR>



" --------------------------------------------------
" Misc
" --------------------------------------------------
filetype plugin indent on
set nrformats=""
set history=200
set runtimepath+=C:\applications\vim74-kaoriya-win64\vimfiles\\*



" --------------------------------------------------
" Plugin
" --------------------------------------------------

" Unite.vim
" ---------
nnoremap <S-u>r :Unite register<CR>
nnoremap <S-u>g :Unite -no-quit vimgrep<CR>
nnoremap <S-q> :Unite buffer -no-quit -keep-focus<CR>:set number<CR>
nnoremap <S-w> :Unite tab<CR>:set number<CR>
"nnoremap <S-u>f :Unite file_mru<CR>
nnoremap <S-u>f :MRU<CR>
nnoremap <S-u>y :Unite history/yank<CR>


" lightline.vim
" -------------
let g:lightline = {
\  'colorscheme': 'wombat',
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


" MRU
" ---
let MRU_Max_Entries = 100
let MRU_Exclude_Files = ".*\.eml$"
let MRU_Window_Height = 30


" JpFormat.vim
" ------------
au BufRead *.eml JpSetAutoFormat!
au BufRead,BufNewFile *.eml let JpFormatCursorMovedI = 1
au BufRead,BufNewFile *.eml let b:JpCountChars = 32
au BufRead,BufNewFile *.eml set colorcolumn=64
"au BufRead,BufNewFile *.eml let b:JpFormatExclude = '^\(>\|http\).*$'
au BufRead,BufNewFile *.eml let b:JpFormatExclude = '^\(>.*\|http.*\)$'



" --------------------------------------------------
" External cooperation
" --------------------------------------------------

" cygwin bash
" -----------
set shell=C:\cygwin64\bin\bash
set shellcmdflag=--login\ -c
set shellxquote=\" 


" External Editor (a thunderbird addon)
" -------------------------------------
function! DeleteSignature()

    let l:internal_domain = '@iij.ad.jp'
    
    let l:line_to  = split(getline(2), ' ')
    let l:line_cc  = split(getline(3), ' ')
    let l:line_bcc = split(getline(4), ' ')
    
    let l:addr_to  = split(line_to[len(line_to)-1], ',')
    let l:addr_cc  = split(line_cc[len(line_cc)-1], ',')
    let l:addr_bcc = split(line_bcc[len(line_bcc)-1], ',')
    
    
    let l:addr_count = len(addr_to) + len(addr_cc) + len(addr_bcc)
    
    let l:internal_domain_count = 0
    
    for addr in addr_to
        if stridx(addr, internal_domain) != -1
            let l:internal_domain_count += 1
        endif
    endfor
    
    for addr in addr_cc
        if stridx(addr, internal_domain) != -1
            let l:internal_domain_count += 1
        endif
    endfor
    
    for addr in addr_bcc
        if stridx(addr, internal_domain) != -1
            let l:internal_domain_count += 1
        endif
    endfor
    
    let l:start = search('^-- $')
    if (addr_count == internal_domain_count) && (start > 0) && (addr_count > 0)
        let l:i = 0
        let l:end = line('$')
        while i < end - start + 1
            execute line('$') . "delete"
            let l:i += 1
        endwhile
    endif

    call cursor(6,1)

endfunction
au BufRead,BufNewFile *.eml call DeleteSignature()

