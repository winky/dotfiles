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
filetype off "ファイルタイプ関連を無効化

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
"自動的に閉じ括弧を入力
imap { {}<LEFT>
imap [ []<LEFT>
imap ( ()<LEFT>
"matchit割当
nmap <Tab> %
vmap <Tab> %

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

    " プラグインリストを収めた TOML ファイル
    let s:toml      = '~/.vim/rc/dein.toml'
    let s:lazy_toml = '~/.vim/rc/dein_lazy.toml'

    " TOML を読み込み、キャッシュしておく
    call dein#load_toml(s:toml,      {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})
    " 設定終了
    call dein#end()
    call dein#save_state()
endif

    " 未インストールものものがあったらインストール
    if dein#check_install()
      call dein#install()
    endif

    filetype plugin indent on
    filetype indent on

endif

"-----------------------------------------------------
"NERDTree.vimの設定
"------------------------------------------------------
" 隠しファイルをデフォルトで表示させる
let NERDTreeShowHidden = 1

" デフォルトでツリーを表示させる
autocmd VimEnter * execute 'NERDTree'
" ツリーの表示非表示切り替え
nnoremap <silent><C-e> :NERDTreeToggle<CR>

"-----------------------------------------------------
"Unite.vimの設定
"------------------------------------------------------
" バッファ一覧
noremap <C-P> :Unite buffer<CR>
" ファイル一覧
noremap <C-N> :Unite -buffer-name=file file<CR>
" 最近使ったファイルの一覧
noremap <C-Z> :Unite file_mru<CR>
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

"-----------------------------------------------------
"lightlineの設定
"------------------------------------------------------
let g:lightline = {
      \   'active': {
      \     'left': [ [ 'mode', 'paste' ], [ 'readonly', 'absolutepath', 'modified' ] ],
      \     'right': [ [ 'lineinfo' ], [ 'percent' ], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \   },
      \   'inactive': {
      \     'left': [ [ 'absolutepath' ] ],
      \     'right': [ [ 'lineinfo' ], [ 'percent' ] ]
      \   },
      \   'tabline': {
      \     'left': [ [ 'tabs' ] ],
      \     'right': [ [ 'close' ] ]
      \   },
      \   'tab': {
      \     'active': [ 'tabnum', 'filename', 'modified' ],
      \     'inactive': [ 'tabnum', 'filename', 'modified' ]
      \   }
      \ }

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

"-----------------------------------------------------
"emmetの設定
"------------------------------------------------------
autocmd BufNewFile,BufRead *.{tpl} set filetype=html
let g:user_emmet_mode='a'
let g:user_emmet_expandabbr_key='<C-a>'

"-----------------------------------------------------
"vim-markdownの設定
"------------------------------------------------------
autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
let g:vim_markdown_folding_disabled=1

"-----------------------------------------------------
"previmの設定
"------------------------------------------------------
let g:previm_show_header=0
let g:previm_custom_css_path='~/.vim/templates/previm/markdown.css'
autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} :Previm
