"
" Ron's Vim Configuration
"
" This is sourced by all Vim-like editors
"

"
" Vim Status (2023-05-05)
"
" Suitable for basic text editing.
"
" Not suitable for Real Programming (tm) due to limitation of no overload
" support in completions.  A vim-lsp bug about this was opened in January 2022
" but was auto-closed by some bot 3 months later with no further comment or
" resolution:
"
" https://github.com/prabirshrestha/vim-lsp/issues/1271
"


"
" NeoVim Status (2023-05)
"
" Work in-progress towards making NeoVim suitable for Real Programming.
"


set nobackup
set nowritebackup
set noswapfile

set visualbell t_vb=

set colorcolumn=121

set encoding=utf8

set fileformats=unix,dos

set number
set cursorline
set cursorlineopt=number

set ruler
set rulerformat=%#ModeMsg#%l,%c%V%=%P

set list
set listchars=tab:>\ ,trail:.,extends:>,precedes:<,nbsp:_
set nohlsearch

set scrolloff=999
set backspace=indent,eol,start
set nofoldenable

set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

set formatoptions+=r
set formatoptions+=o
set formatoptions+=j


"
" GVim
"
if ! has('nvim')
    if has("gui_running")
        if has("gui_win32")
            set guifont=DejaVu_Sans_Mono:h11:cDEFAULT
        else
            set guifont=monospace\ 12
        endif
        set guioptions=arbh
        set columns=120
        set lines=40
    endif
endif


"
" Enable truecolor terminal if supported
"
if ! has("gui_running")
    if $COLORTERM ==# "truecolor"
        set termguicolors
    endif
endif


"
" Color Scheme
"
syntax on
try
  colorscheme macrobsidian
  catch
  try
    colo pablo
    catch
  endtry
endtry


"
" Leader key
"
let mapleader = ' '


"
" Buffers
"
set hidden "Allow unsaved buffers
nmap <silent> <tab> :bnext<cr>
nmap <silent> <s-tab> :bprevious<cr>
" Close the buffer without also nuking the window it's in
nmap <silent> <Leader>bd :bp<bar>sp<bar>bn<bar>bd<CR>


"
" Windows
"
nmap <silent> <Leader>w :close<cr>
nnoremap <silent> <c-j> :wincmd j<cr>
nnoremap <silent> <c-k> :wincmd k<cr>
nnoremap <silent> <c-h> :wincmd h<cr>
nnoremap <silent> <c-l> :wincmd l<cr>


"
" Error list
"
nmap <c-n> :cnext<cr>
nmap <c-p> :cprevious<cr>


"
" Command line
"
set wildmenu
set wildoptions=pum
set wildmode=longest:full
set wildchar=<c-@>
cmap <c-j> <down>
cmap <c-k> <up>
cmap <c-h> <left>
cmap <c-l> <right>


"
" Explorer
"
let g:netrw_winsize = 20
let g:netrw_banner = 0
let g:netrw_liststyle = 0
nmap <Leader>e :Lexplore<cr>
autocmd FileType netrw  call s:SetupNetrwBuffer()
function! s:SetupNetrwBuffer() abort
    nnoremap <silent> <buffer> <c-l> :wincmd l<cr>
    nnoremap <silent> <buffer> <tab> <tab>
    nnoremap <silent> <buffer> <s-tab> <s-tab>
endfunction


"
" Omni Completion
"
filetype plugin on
set omnifunc=syntaxcomplete#Complete
set completeopt=longest,menuone
imap <silent> <expr> <c-j> pumvisible() ? '<c-n>' : '<c-x><c-o>'
imap <silent> <expr> <c-k> pumvisible() ? '<c-p>' : '<c-x><c-o>'
imap <silent> <expr> <c-@> pumvisible() ? '<c-n>' : '<c-x><c-o>'


"
" wilder
"
autocmd VimEnter * call s:SetupWilder()
function! s:SetupWilder() abort
    runtime autoload/wilder.vim
    if ! exists('*wilder#setup') | return | endif

    call wilder#set_option('use_python_remote_plugin', 0)

    call wilder#setup({
        \ 'modes': [':'],
        \ 'next_key': '<down>',
        \ 'previous_key': '<up>',
        \ 'accept_key': '<right>',
        \ 'reject_key': '<left>',
        \ })
    cmap <c-@> <down>

    call wilder#set_option('renderer',
        \ wilder#popupmenu_renderer(
            \ wilder#popupmenu_border_theme({
                \ 'border': 'rounded',
                \ 'min_width': '100%',
                \ 'left': [
                    \ wilder#popupmenu_devicons(),
                    \ ' ',
                \ ],
                \ 'highlights': {
                    \ 'empty_message': 'Normal',
                \ },
                \ 'empty_message': ' (no matches)',
            \ })))
endfunction


"
" nerdtree
"
autocmd StdinReadPre * let s:std_in=1

autocmd VimEnter * call s:SetupNerdTree()
function! s:SetupNerdTree() abort
    if ! exists('g:loaded_nerdtree_autoload') | return | endif
    nnoremap <Leader>e :NERDTreeFocus<cr>
    autocmd FileType nerdtree call s:SetupNerdtreeBuffer()

    " Close Vim when NerdTree becomes the last open window
    autocmd BufEnter *
        \ if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

    " Show NerdTree when Vim started with no file
    if argc() == 0 && !exists('s:std_in') | NERDTree | endif
endfunction

function! s:SetupNerdtreeBuffer() abort
    setlocal cursorlineopt=number,line
    nnoremap <silent> <buffer> <tab> <tab>
    nnoremap <silent> <buffer> <s-tab> <s-tab>
endfunction


"
" vim-lsp
"
autocmd User lsp_setup call s:SetupLsp()

function! s:SetupLsp() abort
    if executable('OmniSharp')
        call lsp#register_server({
            \ 'name': 'omnisharp-roslyn',
            \ 'cmd': [ 'OmniSharp', '-lsp' ],
            \ 'allowlist': [ 'cs' ],
            \ })
    endif
    if executable('bash-language-server')
        call lsp#register_server({
            \ 'name': 'bash-language-server',
            \ 'cmd': [ 'bash-language-server', 'start' ],
            \ 'allowlist': [ 'sh', 'bash' ],
            \ })
    endif
    if executable('serve-d')
        call lsp#register_server({
            \ 'name': 'serve-d',
            \ 'cmd': [ 'serve-d' ],
            \ 'allowlist': [ 'd' ],
            \ })
    endif
    autocmd User lsp_buffer_enabled call s:SetupLspBuffer()

    "
    " LSP Debug Logging
    "
    "let g:lsp_log_file = '/tmp/lsplog.txt'
    "let g:lsp_show_message_log_level = 'log'
endfunction

function! s:SetupLspBuffer() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    " nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    " nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    " nnoremap <buffer> <expr><c-d> lsp#scroll(-4)
    let g:lsp_format_sync_timeout = 1000
endfunction


"
" C#
"
autocmd BufRead *.cs set makeprg=clear\ &&\ dotnet\ build\ /p:GenerateFullPaths=true\ /clp:NoSummary
autocmd BufRead *.cs set efm=%f(%l\\\,%c):\ %tarning\ %m\ [%.%#],%f(%l\\\,%c):\ %trror\ %m\ [%.%#]
autocmd BufRead *.cs nmap <buffer> <Leader>b :exe ':wa'<CR>:silent make<CR>:redr!<CR>:cw<CR>


"
" Shell
"
let g:is_posix = 1


"
" Markdown
"
autocmd BufRead,BufNew *.md set filetype=markdown
let g:markdown_fenced_languages = ["csharp=cs"]


"
" Syntax Highlighting Debugging
"
function! SynStack ()
    let l = line(".")
    let c = col(".")
    echom " "
    echom "Syntax stack (" . l . "," . c . ")"
    for i1 in synstack(l,c)
        let i2 = synIDtrans(i1)
        let n1 = synIDattr(i1, "name")
        let n2 = synIDattr(i2, "name")
        echom n1 "->" n2
    endfor
endfunction
map <leader>s :call SynStack()<cr>:messages<cr>
