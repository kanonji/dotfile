" vim:set ts=4 sts=4 sw=4 tw=0 et

set helplang=ja "helpを日本語優先にする

" UI
set number "行番号表示
set showmode "モード表示
set title "編集中のファイル名を表示
set ruler "ルーラーの表示
set showcmd "入力中のコマンドをステータスに表示する
set showmatch "括弧入力時の対応する括弧を表示
set laststatus=2 "ステータスラインを常に表示
syntax on "カラー表示
set scrolloff=10 "カーソルの上または下に表示する最小限の行数
" 特定のキーに行頭および行末の回りこみ移動を許可する設定
"  b - [Backspace]  ノーマルモード ビジュアルモード
"  s - [Space]      ノーマルモード ビジュアルモード
"  <  - [←]        ノーマルモード ビジュアルモード
"  >  - [→]         ノーマルモード ビジュアルモード
"  [ - [←]         挿入モード 置換モード
"  ] - [→]          挿入モード 置換モード
"  ~ - ~            ノーマルモード
set whichwrap=b,s,<,>,[,],~

" Input
set smartindent "オートインデント

" Tab
set tabstop=4 "タブを表示する際の幅
set shiftwidth=4 "インデント時に使用されるスペースの数
set softtabstop=4 "Tab入力時に挿入するスペースの数
set textwidth=0 "1行の長さ
set expandtab "タブの代わりに空白文字挿入

" http://d.hatena.ne.jp/yuroyoro/20101104/1288879591
" カーソル行をハイライト
set cursorline
set cursorcolumn
" カレントウィンドウにのみ罫線を引く
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
  autocmd WinLeave * set cursorcolumn
  autocmd WinEnter,BufRead * set cursorcolumn
augroup END

highlight clear CursorLine
highlight clear cursorcolumn
" 何故かMacでctermbg=darkgrayが利かないので、反転で代用
highlight CursorLine term=reverse cterm=reverse ctermbg=NONE gui=underline guibg=NONE
highlight cursorColumn term=reverse cterm=reverse ctermbg=NONE guibg=black

"Escの2回押しでハイライト消去
set hlsearch
nmap <ESC><ESC> :nohlsearch<CR><ESC>

set directory=~/.vim/tmp "swpファイルの作成ディレクトリを指定
set backupdir=~/.vim/tmp "~バックアップファイルの作成ディレクトリを指定

" tagfile
if has('path_extra')
    set tags+=tags;~
endif

" バックスペースでインデントや改行を削除できるようにする
" http://www15.ocn.ne.jp/~tusr/vim/vim_text2.html#mozTocId195366
set backspace=indent,eol,start

" status lineに改行コードや文字コードを表示
" http://ks0608.hatenablog.com/entry/2012/02/02/214754
set laststatus=2
set statusline=%n\:%y
set statusline+=[%{(&fenc!=''?&fenc:&enc)}]
set statusline+=[%{Getff()}]
set statusline+=%m%r\ %F%=[%l/%L]

function! Getff()
    if &ff == 'unix'
        return 'LF'
    elseif &ff == 'dos'
        return 'CR+LF'
    elseif &ff == 'mac'
        return 'CR'
    else
        return '?'
    endif
endfunction

" CLI向けにANSI colorを調節
highlight Error term=reverse ctermfg=Black ctermbg=Red
highlight Search term=reverse ctermfg=Black ctermbg=LightYellow

filetype off "pathogenでftdetectなどをロードさせるために一度ファイルタイプ判定をoffにする
"{pathogen}
if('' != glob('~/.vim/bundle/vim-pathogen/'))
    call pathogen#runtime_append_all_bundles()
    call pathogen#helptags()
endif
filetype plugin on "filetype plugin on が filetype on も暗黙的にやる
filetype indent on

" neocomplcache
if('' != glob('~/.vim/bundle/neocomplcache/'))
    let g:neocomplcache_enable_at_startup = 1 " 起動時に有効化
    "let g:neocomplcache_enable_auto_select = 1 " 1番目の候補を自動選択
    " 候補表示時はEnterで確定。それ以外は改行
    inoremap <expr><CR>    pumvisible() ? neocomplcache#smart_close_popup() : "\<CR>"
    " Tabで次の候補
    inoremap <expr><TAB>   pumvisible() ? "\<C-n>" : "\<TAB>"
    " Shift tabで前の候補
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
    highlight Pmenu ctermbg=Black
endif

" quickrun
if('' != glob('~/.vim/bundle/vim-quickru/'))
    let g:quickrun_config = {}
    " let g:quickrun_config['php'] = {'outputter': 'browser'}
endif

" tcomment
if('' != glob('~/.vim/bundle/tcomment_vim/'))
    if !exists('g:tcomment_types')
        let g:tcomment_types = {}
    endif
    let g:tcomment_types = {
        \'phptag_inline' : "<?php %s ?>",
        \'phptag_echo_inline' : "<?php echo %s ?>",
    \}
    au FileType php nmap <buffer><C-_>j :TCommentAs phptag_inline<CR>
    au FileType php vmap <buffer><C-_>j :TCommentAs phptag_inline<CR>
    au FileType php nmap <buffer><C-_>k :TCommentAs phptag_echo_inline<CR>
    au FileType php vmap <buffer><C-_>k :TCommentAs phptag_echo_inline<CR>
endif
