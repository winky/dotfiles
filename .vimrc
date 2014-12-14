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
nnoremap ` /

filetype off "ファイルタイプ関連を無効化

if has('vim_starting')
	 set runtimepath+=~/.vim/bundle/neobundle.vim/
	 call neobundle#rc(expand('~/.vim/bundle'))
endif

"gitを使ったプラグインマネージャー
NeoBundleFetch 'Shougo/neobundle.vim'

"------------------------------------------------------
"github（プラグイン）
"------------------------------------------------------
"make時のエラーマーカー表示
NeoBundle 'errormarker.vim'
"キャッシュを備えた自動補完機能
NeoBundle 'Shougo/neocomplete.vim'
"コードスニペット
NeoBundle 'Shougo/neosnippet'
"ファイルプラグイン
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'LeafCage/yankround.vim'
NeoBundle 'Shougo/unite.vim'
"SQL整形のために必要なプラグイン
NeoBundle 'Align'
"PHPシンタックスハイライト
NeoBundle 'shawncplus/php.vim'

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

source $HOME/dotfiles/.vimrc.neocomplete
source $HOME/dotfiles/.vimrc.colorconfig
source $HOME/dotfiles/.vimrc.yankround
