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
" FileType
" --------------------------------------------------
if len(&filetype) == 0
  set filetype=log
endif


" --------------------------------------------------
" Tab
" --------------------------------------------------
nnoremap <C-n> gt
nnoremap <C-p> gT
nnoremap tt :tabnew<CR>

" 各タブページのカレントバッファ名+αを表示
function! s:tabpage_label(n)
  " t:title と言う変数があったらそれを使う
  let title = gettabvar(a:n, 'title')
  if title !=# ''
    return title
  endif

  " タブページ内のバッファのリスト
  let bufnrs = tabpagebuflist(a:n)

  " カレントタブページかどうかでハイライトを切り替える
  let hi = a:n is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'

  " バッファが複数あったらバッファ数を表示
  let no = len(bufnrs)
  if no is 1
    let no = ''
  endif
  " タブページ内に変更ありのバッファがあったら '+' を付ける
  let mod = len(filter(copy(bufnrs), 'getbufvar(v:val, "&modified")')) ? '+' : ''
  let sp = (no . mod) ==# '' ? '' : ' '  " 隙間空ける

  " カレントバッファ
  let curbufnr = bufnrs[tabpagewinnr(a:n) - 1]  " tabpagewinnr() は 1 origin
  let fname = pathshorten(bufname(curbufnr))

  let label = no . mod . sp . fname

  return '%' . a:n . 'T' . hi . label . '%T%#TabLineFill#'
endfunction

function! MakeTabLine()
  let titles = map(range(1, tabpagenr('$')), 's:tabpage_label(v:val)')
  let sep = ' | '  " タブ間の区切り
  let tabpages = join(titles, sep) . sep . '%#TabLineFill#%T'
  let info = ''  " 好きな情報を入れる
  return tabpages . '%=' . info  " タブリストを左に、情報を右に表示
endfunction

set tabline=%!MakeTabLine()


" --------------------------------------------------
" Plugin
" --------------------------------------------------
