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
set matchtime=3 "対応括弧の表示秒数を3秒にする
set showcmd "入力中のコマンドをステータスに表示
set laststatus=2 "ステータスラインを常に表示
syntax on "コードの色分け
highlight Commnet ctermfg=DarkCyan
set wildmenu "コマンドライン補完を拡張モードにする
set wrap "折り返して表示
set cursorline "カーソル行の背景変更
set number "行番号を表示
if has ('nvim')
    set guicursor=i-ci-ve:block
endif

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
if has('nvim')
    set clipboard=unnamed
else
    set clipboard=unnamed,autoselect
endif
set ruler "ルーラーの表示

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
"行移動入れ替え
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
"検索機能
nnoremap ` /

"------------------------------------------------------
"プラグイン管理
"------------------------------------------------------
if has('vim_starting')
    " dein settings
    if &compatible
        set nocompatible
    endif

    " dein.vimのディレクトリ
    let s:dein_dir = expand('~/.cache/dein')
    " dein.vim 本体
    let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

    " dein.vivmがなければgithubから落としてくる
    if &runtimepath !~# '/dein.vim'
        if !isdirectory(s:dein_repo_dir)
            execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
        endif
        execute 'set runtimepath+=' . fnamemodify(s:dein_repo_dir, ':p')
    endif

    " 設定開始
    if dein#load_state(s:dein_dir)
        call dein#begin(s:dein_dir)
        let s:toml_dir = '~/.vim/rc'

        " プラグインリストを収めた TOML ファイル
        let s:toml          = s:toml_dir . '/dein.toml'
        let s:lazy_toml     = s:toml_dir . '/dein_lazy.toml'
        let s:syntax_toml   = s:toml_dir . '/dein_lazy_syntax.toml'
        let s:mkd_toml      = s:toml_dir . '/dein_lazy_markdown.toml'
        let s:js_toml       = s:toml_dir . '/dein_lazy_javascript.toml'

        " TOML を読み込み、キャッシュしておく
        call dein#load_toml(s:toml,         {'lazy': 0})
        call dein#load_toml(s:lazy_toml,    {'lazy': 1})
        call dein#load_toml(s:syntax_toml,  {'lazy': 1})
        call dein#load_toml(s:mkd_toml,     {'lazy': 1})
        call dein#load_toml(s:js_toml,      {'lazy': 1})
        " 設定終了
        call dein#end()
        call dein#save_state()
    endif

    " 未インストールものものがあったらインストール
    if dein#check_install()
      call dein#install()
    endif

    filetype plugin indent on
endif

" http://inari.hatenablog.com/entry/2014/05/05/231307
"-----------------------------------------------------
"全角スペースの表示
"------------------------------------------------------
function! ZenkakuSpace()
   highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction

if has('syntax')
    aug ZenkakuSpace
        au!
        au ColorScheme * call ZenkakuSpace()
        au VimEnter,WinEnter,BufRead * let w:m1=matchadd('ZenkakuSpace', '　')
    aug END
    call ZenkakuSpace()
endif
