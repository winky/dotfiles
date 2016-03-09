"------------------------------------------------------
"基本設定
"------------------------------------------------------
set encoding=UTF-8
set fileencoding=UTF-8
set termencoding=UTF-8
set nocompatible "viの互換をなくす
set backspace=indent,eol,start "バックスペースの挙動
colorscheme molokai

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
set cursorline "カーソル行の背景変更

"------------------------------------------------------
"折りたたみ関連
"------------------------------------------------------
set foldenable
"set foldopen=all "fold内に移動すれば自動で開く
"set foldclose=all
set foldlevel=2 "折り畳み具合
set foldmethod=indent "折畳処理のパターン
set foldcolumn=6 "折畳を示すカラム幅
set foldnestmax=6 "折畳のシンタックスの最大数

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
"NERDTreeプラグイン"
nnoremap <silent><C-e> :NERDTreeToggle<CR>
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

let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vivmがなければgithubから落としてくる
if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_dir)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
    endif
    execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
call dein#begin(s:dein_dir)

" プラグインリストを収めた TOML ファイル
let s:toml      = '~/.vim/rc/dein.toml'
let s:lazy_toml = '~/.vim/rc/dein_lazy.toml'


" TOML を読み込み、キャッシュしておく
if dein#load_cache([expand('<sfile>'), s:toml, s:lazy_toml])
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})
  call dein#save_cache()
endif


" 設定終了
call dein#end()

" 未インストールものものがあったらインストール
if dein#check_install()
  call dein#install()
endif

" if &compatible
"  set nocompatible   " Be iMproved0 endif
" endif
" set runtimepath+=~/dotfiles/.vim/bundle/neobundle.vim/

" call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

"------------------------------------------------------
"github（プラグイン）
"------------------------------------------------------
" NERDTreeを設定
NeoBundle 'scrooloose/nerdtree'
" make時のエラーマーカー表示
NeoBundle 'errormarker.vim'
" Vimステータスライン
NeoBundle 'itchyny/lightline.vim'
" キャッシュを備えた自動補完機能
NeoBundle 'Shougo/neocomplete.vim'
" コードスニペット
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
" インデントに色を付けて見やすくする
NeoBundle 'nathanaelkane/vim-indent-guides'
" 置換ハイライト
NeoBundle 'osyo-manga/vim-over'
" 行末の半角スペースを可視化
NeoBundle 'bronson/vim-trailing-whitespace'
" 括弧自動補完
NeoBundle 'Townk/vim-autoclose'
" molokai カラースキーム
NeoBundle 'tomasr/molokai'
" 囲いを簡易化
NeoBundle 'tpope/vim-surround'
" editorconfig有効化
NeoBundle 'editorconfig/editorconfig-vim'

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
"NERDTree.vimの設定
"------------------------------------------------------
" 隠しファイルをデフォルトで表示させる
let NERDTreeShowHidden = 1

" デフォルトでツリーを表示させる
autocmd VimEnter * execute 'NERDTree'

"-----------------------------------------------------
"vim-indent-guidesの設定
"------------------------------------------------------
" vimを立ち上げたときに、自動的にvim-indent-guidesをオンにする
let g:indent_guides_enable_on_vim_startup = 1
" 自動カラー無効
let g:indent_guides_auto_colors=0
" 奇数番目のインデントの色
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#444433 ctermbg=black
" 偶数番目のインデントの色
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#333344 ctermbg=darkgray

" http://inari.hatenablog.com/entry/2014/05/05/231307
"-----------------------------------------------------
"全角スペースの表示
"------------------------------------------------------
function! ZenkakuSpace()
   highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme * call ZenkakuSpace()
        autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
    augroup END
    call ZenkakuSpace()
endif
