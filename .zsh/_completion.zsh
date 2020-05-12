fpath=($fpath $DOTFILES/.zsh/completion/src)

# 補完候補がなければより曖昧に候補を探す。
# m:{a-z}={A-Z}: 小文字を大文字に変えたものでも補完する。
# r:|[._-]=*: 「.」「_」「-」の前にワイルドカード「*」があるものとして補完する。
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[-_.]=**'
# 詳細な情報を使う
zstyle ':completion:*' verbose yes

zstyle ':completion:*' keep-prefix
zstyle ':completion:*' recent-dirs-insert both

# 補完方法毎にグループ化する。
zstyle ':completion:*' group-name ''
zstyle ':completion:*' format '%B%F{blue}%d%f%b'
# 補完候補に色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# 補完候補をキャッシュする。
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path $DOTFILES/.zsh/cache
# 補完候補
# _oldlist 前回の補完結果を再利用する。
# _complete: 補完する。
# _match: globを展開しないで候補の一覧から補完する。
# _history: ヒストリのコマンドも補完候補とする。
# _ignored: 補完候補にださないと指定したものも補完候補とする。
# _approximate: 似ている補完候補も補完候補とする。
# _prefix: カーソル以降を無視してカーソル位置までで補完する。
zstyle ':completion:*' completer _oldlist _complete _match _history _ignored _approximate _prefix
# 補完侯補をメニューから選択する。
# select=2: 補完候補を一覧から選択する。補完候補が2つ以上なければすぐに補完する。
zstyle ':completion:*:default' menu select=2

zstyle ':completion:*:sudo:*' command-path $PATH
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'
zstyle ':completion:*:warnings' format 'No matches for: %d'
