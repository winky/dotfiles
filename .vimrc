"------------------------------------------------------
"基本設定
"------------------------------------------------------
set encoding=UTF-8
set fileencoding=UTF-8
set termencoding=UTF-8

set nocompatible "viの互換をなくす
set backspace=indent,eol,start "バックスペースの挙動

"------------------------------------------------------
"表示設定
"------------------------------------------------------
set hlsearch "検索文字列ハイライト
set showmatch "括弧入力時の対応する括弧を表示
set showcmd "入力中のコマンドをステータスに表示
set laststatus=2 "ステータスラインを常に表示
syntax on "コードの色分け
highlight Commnet ctermfg=DarkCyan
set wildmenu "コマンドライン補完を拡張モードにする
set wrap "折り返して表示

"------------------------------------------------------
"検索関係
"------------------------------------------------------
set history=100 "履歴を100個まで記録
set ignorecase "検索時に大文字小文字を区別しない
set smartcase "検索時に大文字が含まれている場合は区別する
set wrapscan "最後まで検索したら頭に戻る
set incsearch "インクリメントサーチ

set clipboard=unnamed,autoselect
set ruler "ルーラーの表示
"------------------------------------------------------
"インデント
"------------------------------------------------------
set tabstop=4 "タブ幅をスペース4つ分に
set shiftwidth=4 "自動インデントの幅
set softtabstop=4 "タブやバックスペースの使用時のタブ幅

"------------------------------------------------------
"環境設定
"------------------------------------------------------
set noswapfile "swapファイルをつくらない
set nowritebackup "バックアップファイルを作らない
set nobackup "バックアップしない

"------------------------------------------------------
"独自設定
"------------------------------------------------------
set scrolloff=5 "スクロール時の余白確保
set autoread "他で書き換えられたら自動的に読み直す
set number "行番号を表示
set autoindent "インデントを自動で
set expandtab "タブをスペースインデントに変更"
set whichwrap=b,s,h,l,[,],<,> "カーソルで次の行へ
set wildchar=<tab> "コマンド補完を開始するキー
let php_sql_query = 1

"------------------------------------------------------
"キーバインド
"------------------------------------------------------
"インサートモードでもhjkl移動できるように
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
"インサードモードでjjでノーマルモードに戻る
inoremap jj <Esc>
";と:の機能を入れ替える
nnoremap ; :
nnoremap : ;
"uniteプラグイン
nmap <Space>u [unite]
nnoremap <silent>[unite]y :<C-u>Unite yankround<CR>
"行移動入れ替え
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
"検索機能
nnoremap ` /
"自動的に閉じ括弧を入力
imap { {}<LEFT>
imap [ []<LEFT>
imap ( ()<LEFT>

filetype off "ファイルタイプ関連を無効化

if has('vim_starting')
	if &compatible
	 set nocompatible   " Be iMproved0 endif
	endif
	 set runtimepath+=~/dotfiles/.vim/bundle/neobundle.vim/
endif

call neobundle#begin(expand('$HOME/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

"------------------------------------------------------
"github（プラグイン）
"------------------------------------------------------
"make時のエラーマーカー表示
NeoBundle 'errormarker.vim'
"キャッシュを備えた自動補完機能
NeoBundle 'Shougo/neocomplete.vim'
""コードスニペット
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/unite.vim'

filetype plugin on
filetype indent on

"vimproc自動アップデート
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
call neobundle#end()

"-----------------------------------------------------
"Uinte.vimの設定
"------------------------------------------------------
" 入力モードで開始する
let g:unite_enable_start_insert=1
" バッファ一覧
noremap <C-P> :Unite buffer<CR>
" ファイル一覧
noremap <C-N> :Unite -buffer-name=file file<CR>
" 最近使ったファイルの一覧
noremap <C-Z> :Unite file_mru<CR>
