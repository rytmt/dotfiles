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
set fileencodings=utf-8,cp932,euc-jp,utf-16le
set fileformat=unix
set fileformats=unix,dos
set termencoding=UTF-8


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
set nrformats=
nnoremap x "_x
nnoremap Y v$hy
nnoremap ya :call YankLineWithoutCR()<CR>
nnoremap <S-j> 10j
nnoremap <S-k> 10k
nnoremap <S-h> 10h
nnoremap <S-l> 10l
nnoremap <C-n> :tabnext<CR>
nnoremap <C-p> :tabprevious<CR>
nnoremap <C-t> :tabedit %<CR>
nnoremap <C-s> :w<CR>
nnoremap <C-q> :bw!<CR>
nnoremap :fpath :echo expand("%:p")<CR>
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-u> <Esc>ui
inoremap <C-r> <Esc><C-r>i
inoremap <C-s> <Esc>:w<CR>
inoremap <C-q> <Esc>:bw!<CR>
vunmap <C-x>


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
augroup highlightSpace
  autocmd!
  autocmd Colorscheme * highlight IdeographicSpace guibg=#444444
  autocmd Colorscheme * highlight HeadNormalSpace  gui=underline guifg=#663333
  autocmd Colorscheme * highlight TailNormalSpace  gui=underline guifg=#663333
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


" Session
" -------
set sessionoptions=buffers
nnoremap :mks :mksession! C:\applications\vim74-kaoriya-win64\Session.vim<CR>
nnoremap :rds :source C:\applications\vim74-kaoriya-win64\Session.vim<CR>


" Others
" ------
filetype plugin indent on
set history=200
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


" yank current cursor line without \n
function! YankLineWithoutCR()
    call feedkeys(":let row = line('.')\<CR>")
    call feedkeys(":let col = col('.')\<CR>")
    call feedkeys("^y$")
    call feedkeys(":call cursor(row, col)\<CR>")
endfunction


" for markdown(.md) file
au BufRead,BufNewFile *.md abbreviate tl - [ ]
au BufRead,BufNewFile *.md call CheckedList()
au BufRead,BufNewFile *.md call ColorPriority()
au BufRead,BufNewFile *.md nnoremap <C-c> :call ToggleCheckbox()<CR>
au BufRead,BufNewFile *.md nnoremap <C-Tab> :call AddPriority()<CR>
au BufRead,BufNewFile *.md nnoremap <C-S-Tab> :call RemovePriority()<CR>
function! ToggleCheckbox()
    let l:line = getline('.')
    if l:line =~ '\-\s\[\s\]'
        let l:result = substitute(l:line, '\-\s\[\s\]', '- [x]', '')
        call setline('.', l:result)
    elseif l:line =~ '\-\s\[x\]'
        let l:result = substitute(l:line, '\-\s\[x\]', '- [ ]', '')
        call setline('.', l:result)
    end
endfunction
function! CheckedList()
    syntax match checkedlist "\-\s\[x\].\+$" display containedin=ALL
    highlight checkedlist guifg=#888888
endfunction
function! AddPriority()
    call setline('.', substitute(getline('.'), '\-\s\[\s\]', '- [ ]\t', ''))
endfunction
function! RemovePriority()
    call setline('.', substitute(getline('.'), '\-\s\[\s\]\t', '- [ ]', ''))
endfunction
function! ColorPriority()
    syntax match priority_green "\-\s\[\s\]\t[^\t]\+$" display containedin=ALL
    highlight priority_green guifg=#b5bd68
    syntax match priority_yellow "\-\s\[\s\]\t\t[^\t]\+$" display containedin=ALL
    highlight priority_yellow guifg=#cd853f
    syntax match priority_red "\-\s\[\s\]\t\t\t.\+$" display containedin=ALL
    highlight priority_red guifg=#cc6666
endfunction


" for email(.eml) file
au BufRead,BufNewFile *.eml nnoremap <C-q> :q<CR>

" Depend on JpFormat.vim
au BufRead *.eml JpSetAutoFormat!
au BufRead,BufNewFile *.eml let JpFormatCursorMovedI = 1
au BufRead,BufNewFile *.eml let b:JpCountChars = 32
au BufRead,BufNewFile *.eml set colorcolumn=64
"au BufRead,BufNewFile *.eml let b:JpFormatExclude = '^\(>\|http\).*$'
au BufRead,BufNewFile *.eml let b:JpFormatExclude = '^\(>.*\|http.*\)$'

" Delete signature (for thunderbird addon 'External Editor')
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

