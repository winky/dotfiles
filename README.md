# Private dotfiles

[![github](https://github.com/winky/dotfiles/workflows/CI/badge.svg)](https://github.com/winky/dotfiles/workflows/CI/)

個人用のdotfilesリポジトリです。開発環境を効率的にセットアップするための設定ファイルを管理しています。

## 📋 概要

このリポジトリには、以下の開発ツールの設定が含まれています：

- **Shell**: zsh, bash
- **Editor**: Neovim (lazy.nvim), Vim (dein.vim)
- **Terminal**: tmux
- **その他**: Git, Karabiner, peco

## 🚀 クイックスタート

### インストール

```bash
git clone https://github.com/winky/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make install
```

### セットアップ手順

1. **基本設定のデプロイ**
   ```bash
   make deploy
   ```

2. **設定ディレクトリのシンボリックリンク作成**
   ```bash
   make homeConfig
   ```

## 🛠️ 主要な機能

### Shell (zsh)

- **プラグインマネージャー**: zinit
- **プロンプト**: starship（利用可能な場合）、またはカスタムテーマ `winky.zsh-theme`
- **ディレクトリナビゲーション**: zoxide（利用可能な場合）
- **モダンなCLIツール**:
  - `eza` - `ls`の代替（アイコン、Git統合）
  - `bat` - `cat`の代替（シンタックスハイライト）
  - `ripgrep` (rg) - `grep`の代替（高速検索）
  - `fd` - `find`の代替（高速ファイル検索）
  - `lazygit` - Git TUI

### Neovim

- **プラグインマネージャー**: lazy.nvim
- **カラースキーム**: nightfox
- **LSP**: Neovim 0.11+ ネイティブLSP API
  - 対応言語: Lua, Python, TypeScript/JavaScript, Go, PHP
- **補完**: nvim-cmp + LuaSnip
- **ファイル管理**: nvim-tree.lua
- **検索**: telescope.nvim
- **ステータスライン**: lualine.nvim
- **Lint**: nvim-lint
- **その他**:
  - nvim-autopairs（自動ペア）
  - Comment.nvim（コメント機能）
  - indent-blankline.nvim（インデントガイド）

### Vim

- **プラグインマネージャー**: dein.vim
- **カラースキーム**: molokai
- **主要プラグイン**:
  - lightline.vim（ステータスライン）
  - NERDTree（ファイルエクスプローラー）
  - vim-fugitive（Git統合）
  - vim-gitgutter（Git差分表示）

### tmux

- **プラグインマネージャー**: TPM (Tmux Plugin Manager)
- **設定**: カスタムキーバインド、ペイン分割、セッション管理

### Git

- **設定**: `config/git/config`
- **無視ファイル**: `config/git/ignore`
- **便利なエイリアス**: zsh/bashに多数のGitエイリアスを定義

## 📁 ディレクトリ構成

```
.dotfiles/
├── .zsh/              # zsh設定ファイル
│   ├── _aliases.zsh   # エイリアス定義
│   ├── _env.zsh       # 環境変数
│   ├── _functions.zsh # カスタム関数
│   ├── _keybinds.zsh  # キーバインド
│   ├── _completion.zsh # 補完設定
│   ├── themes/        # カスタムプロンプトテーマ
│   └── zinit.zsh      # zinit設定
├── .vim/              # Vim設定
│   ├── colors/        # カラースキーム
│   └── rc/            # dein.vimプラグイン設定
├── .tmux/             # tmux設定
│   └── plugins/       # TPMプラグイン
├── config/             # XDG Base Directory準拠の設定
│   ├── nvim/          # Neovim設定（lazy.nvim）
│   ├── git/            # Git設定
│   └── karabiner/      # Karabiner設定（macOS）
├── .zshrc              # zshメイン設定
├── .vimrc               # Vim/Neovim基本設定
├── .tmux.conf           # tmux設定
└── Makefile            # 管理用Makefile
```

> **💡 ヒント**: `make help` を実行すると、利用可能なすべてのMakefileコマンドとその説明が表示されます。

## 🎨 カスタマイズ

### 新しいプラグインの追加

#### Neovim
`config/nvim/lua/plugins/` ディレクトリに新しい `.lua` ファイルを作成します。

例: `config/nvim/lua/plugins/my-plugin.lua`
```lua
return {
  "username/plugin-name",
  config = function()
    -- 設定
  end,
}
```

#### Vim
`.vim/rc/dein.toml` または適切なlazy TOMLファイルに追加します。

### シェルエイリアスの追加

- zsh: `.zsh/_aliases.zsh` を編集
- bash: `.bashrc` を編集

### プロンプトの変更

- starshipを使用する場合: `starship.toml` を編集
- カスタムテーマを使用する場合: `.zsh/themes/winky.zsh-theme` を編集

## 🔄 更新方法

```bash
cd ~/.dotfiles
make update
```

または手動で：

```bash
git pull origin master
git submodule update --init --recursive
```

## 📝 注意事項

- このリポジトリは個人用の設定です
- 環境によっては一部のツールが利用できない場合があります（条件付きロードで対応）
- Neovim 0.11以上を推奨
- macOSとLinuxの両方で動作しますが、一部の設定はmacOS専用です（Karabinerなど）

## 📄 ライセンス

Private repository
